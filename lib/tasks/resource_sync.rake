# frozen_string_literal: true

require 'faraday'
require 'json'
require 'nokogiri'
require 'modules/slugger'
require 'modules/url_sanitizer'

namespace :resource_sync do
  desc 'Sync DIAL resources data with wordpress API.'
  task sync_dial_resources: :environment do
    task_name = 'Sync DIAL Resources'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    DEFAULT_RESOURCE_TOPICS = [
      'Enabling Environment',
      'Oversight & Accountability',
      'Participation & Agency',
      'Technical Insights'
    ]

    # Some of the resources' content is not returned by the wordpress API, so we need to
    # fetch them from the wordpress site and then parse it with nokogiri and then  sync
    # them with the database.
    # https://stackoverflow.com/q/43381617
    # Last content with proper content in the renderer field: "2023-01-05T05:51:42".

    # Fetch all resources from wordpress API
    current_page = 1
    wp_base = 'https://dial.global'
    wp_research_base = '/wp-json/wp/v2/research'

    still_seeing_resources = true
    while still_seeing_resources
      wp_post_query = "?page=#{current_page}"

      connection = Faraday.new(url: wp_base)
      connection.basic_auth(ENV['WP_AUTH_USER'], ENV['WP_AUTH_PASSWORD'])

      response = connection.get("#{wp_research_base}#{wp_post_query}")
      response_body = JSON.parse(response.body)

      # Last page of the /wp/v2/posts API:
      # {
      #   "code": "rest_post_invalid_page_number",
      #   "message": "The page number requested is larger than the number of pages available.",
      #   "data": {
      #     "status": 400
      #   }
      # }
      #
      # Page with data will have structure like this:
      # [
      #   {
      #     "id": 1641
      #     ... more post's fields
      #   },
      #   {
      #     "id": 1642
      #     ... more post's fields
      #   },
      # ]

      if response_body.is_a?(Hash)
        still_seeing_resources = false
      else
        response_body.each do |post_structure|
          puts "Processing resource: #{CGI.unescapeHTML(post_structure['title']['rendered'])}"
          process_dial_resource(post_structure)
        end
      end

      current_page += 1
    end

    tracking_task_finish(task_name)
  end

  def process_dial_resource(post_structure)
    resource_name = CGI.unescapeHTML(post_structure['title']['rendered'])
    resource_slug = post_structure['slug']
    resource = Resource.name_and_slug_search(resource_name, resource_slug).first
    if resource.nil?
      resource = Resource.new(name: resource_name, slug: resource_slug, phase: 'Not Applicable')
      if Resource.where(slug: resource.slug).count.positive?
        # Check if we need to add _dup to the slug.
        first_duplicate = Resource.slug_simple_starts_with(resource.slug)
                                  .order(slug: :desc)
                                  .first
        resource.slug += generate_offset(first_duplicate)
      end
    end

    resource.resource_link = cleanup_url(post_structure['link'])
    resource.description = post_structure['excerpt']['rendered']
    resource.published_date = safe_parse_date(post_structure['date'])

    resource.show_in_wizard = false
    resource.show_in_exchange = true

    successful_operation = false
    ActiveRecord::Base.transaction do
      tag_current_page = 1
      wp_base = 'https://dial.global'
      wp_tag_base = '/wp-json/wp/v2/tags'

      resource_tags = []
      resource_topics = []
      still_seeing_tags = true
      while still_seeing_tags
        wp_tag_query = "?post=#{post_structure['id']}&page=#{tag_current_page}"

        connection = Faraday.new(url: wp_base)
        connection.basic_auth(ENV['WP_AUTH_USER'], ENV['WP_AUTH_PASSWORD'])

        tag_response = connection.get("#{wp_tag_base}#{wp_tag_query}")
        tag_response_body = JSON.parse(tag_response.body)

        if tag_response_body.is_a?(Array) && tag_response_body.empty?
          still_seeing_tags = false
        else
          tag_response_body.each do |tag_structure|
            tag_name = tag_structure['name']
            tag = Tag.find_by(slug: reslug_em(tag_name))
            tag = Tag.find_by(name: tag_name) if tag.nil?
            tag = Tag.new(name: tag_name, slug: reslug_em(tag_name)) if tag.nil?
            # Save the new tag to the database.
            tag.save!
            # Assign tag to the resource.
            resource_tags << tag.name

            next unless DEFAULT_RESOURCE_TOPICS.include?(tag_name)

            resource_topic = ResourceTopic.find_by(name: tag_name)
            if resource_topic.nil?
              resource_topic = ResourceTopic.new(name: tag_name, slug: reslug_em(tag_name))
            end
            # Save the new resource topic to the database.
            resource_topic.save!
            # Assign resource topic to the resource.
            resource_topics << resource_topic.name unless resource_topic.nil?
          end
        end

        tag_current_page += 1
      end
      resource.tags = resource_tags
      resource.resource_topics = resource_topics

      resource.authors = []

      authors = post_structure['_links']['author']
      authors.each do |author|
        author_href = author['href']
        next if author_href.nil?

        author_connection = Faraday.new(author_href)
        author_connection.basic_auth(ENV['WP_AUTH_USER'], ENV['WP_AUTH_PASSWORD'])

        author_href_response = author_connection.get('')
        author_href_response_body = JSON.parse(author_href_response.body)

        next if !author_href_response_body['data'].nil? && author_href_response_body['data']['status'] == 401

        resource_author = Author.find_by(name: author_href_response_body['name'])
        resource_author = Author.find_by(slug: reslug_em(author_href_response_body['name'])) if resource_author.nil?
        resource_author = Author.new if resource_author.nil?

        resource_author.name = author_href_response_body['name']
        resource_author.slug = reslug_em(author_href_response_body['name'])

        avatar_api = 'https://ui-avatars.com/api/?name='
        avatar_params = '&background=2e3192&color=fff&format=svg'
        resource_author.picture = "#{avatar_api}#{resource_author.name.gsub(/\s+/, '+')}#{avatar_params}"

        if resource_author.new_record? || !resource.authors.include?(resource_author)
          resource.authors << resource_author
        end
      end

      source_organization = Organization.find_by(slug: 'digital-impact-alliance')
      unless source_organization.nil?
        resource.organization_id = source_organization.id
      end

      resource.save!
      successful_operation = true
    end

    if successful_operation
      puts "  Resource '#{resource.name}' record saved."
    end
  end

  task :sync_dpi_resources, [:resource_file] => :environment do |_, _params|
    ENV['resource_file'].nil? ? resource_file = 'DPIResources.csv' : resource_file = ENV['resource_file']
    task_name = 'Sync DPI Resources'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    file_path = './utils/' + resource_file
    csv_data = CSV.parse(File.read(file_path), headers: true)

    csv_data.each_with_index do |dpi_resource, _index|
      resource_name = dpi_resource[1]
      tracking_task_log(task_name, "Processing resource: #{resource_name}.")

      resource_name = resource_name
      resource_slug = reslug_em(resource_name)
      resource = Resource.name_and_slug_search(resource_name, resource_slug).first
      if resource.nil?
        resource = Resource.new(name: resource_name, slug: resource_slug, phase: 'Not Applicable')
        if Resource.where(slug: resource.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Resource.slug_simple_starts_with(resource.slug)
                                    .order(slug: :desc)
                                    .first
          resource.slug += generate_offset(first_duplicate)
        end
      end

      resource.resource_type = dpi_resource[2]

      authors = []
      authors = dpi_resource[3].split(',') unless dpi_resource[5].nil?
      authors.each do |author|
        author_name = author.strip
        resource_author = Author.find_by(name: author_name)
        resource_author = Author.find_by(slug: reslug_em(author_name)) if resource_author.nil?
        resource_author = Author.new if resource_author.nil?

        resource_author.name = author_name
        resource_author.slug = reslug_em(author_name)
        avatar_api = 'https://ui-avatars.com/api/?name='
        avatar_params = '&background=2e3192&color=fff&format=svg'
        resource_author.picture = "#{avatar_api}#{resource_author.name.gsub(/\s+/, '+')}#{avatar_params}"

        resource.authors << resource_author unless resource_author.nil? || resource.authors.include?(resource_author)
      end

      # Link to an organization
      org_name = dpi_resource[5]
      resource_org = Organization.first_duplicate(org_name.strip, reslug_em(org_name.strip))
      if resource_org.nil?
        resource_org = Organization.new
        resource_org.name = org_name
        resource_org.slug = reslug_em(org_name)
        resource_org.save!
      end

      resource.organization = resource_org

      resource.resource_link = cleanup_url(dpi_resource[7])

      # Try to get the image
      image_saved = false
      begin
        # rubocop:disable Security/Open
        og_image = Nokogiri::HTML(URI.open(dpi_resource[6])).at_css("meta[property='og:image']")
        unless og_image.blank?
          puts og_image['content']
          upload_user = User.find_by(username: 'admin')
          uploader = LogoUploader.new(resource, resource.resource_link, upload_user)
          uploader.download!(og_image['content'])
          uploader.store!
          image_saved = true
        end
      rescue StandardError => e
        puts "Unable to save image for: #{resource.name}. Standard error: #{e}."
      end

      if !image_saved && resource_org.image_file != '/assets/organizations/organization-placeholder.png'
        # try the organization logo
        puts resource_org.image_file
        upload_user = User.find_by(username: 'admin')
        uploader = LogoUploader.new(resource, resource.resource_link, upload_user)
        uploader.store!(resource_org.image_file)
      end

      resource.description = dpi_resource[7]

      resource.save!
      puts "  Resource '#{resource.name}' record saved."
    end

    tracking_task_finish(task_name)
  end

  desc 'Read DPI Readings.xlsx file and then save it to the database.'
  task sync_dpi_readings: :environment do
    task_name = 'Sync DPI Readings'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    DEFAULT_RESOURCE_TOPICS = [
      'Enabling Environment',
      'Oversight & Accountability',
      'Participation & Agency',
      'Technical Insights'
    ]

    workbook = Roo::Spreadsheet.open('./data/spreadsheet/DPI-Readings.xlsx')
    workbook.default_sheet = 'List 2'

    worksheet_headers = workbook.row(1).map { |header| header.gsub(/\A\p{Space}*|\p{Space}*\z/, '') }
    puts "Worksheet headers: #{worksheet_headers.inspect}."

    2.upto(workbook.last_row) do |row_count|
      current_row = workbook.row(row_count)
      current_row_sanitized = current_row.map { |cell| cell.to_s.gsub(/\A\p{Space}*|\p{Space}*\z/, '') }
      current_row_data = Hash[worksheet_headers.zip(current_row_sanitized)]

      resource_name = current_row_data['Article Title']
      next if resource_name.blank?

      puts "Processing row #{row_count} --> with title: #{resource_name}."

      resource_slug = reslug_em(resource_name)
      existing_resource = Resource.name_and_slug_search(resource_name, resource_slug).first
      if existing_resource.nil?
        existing_resource = Resource.new(name: resource_name, slug: resource_slug, phase: 'Not Applicable')
        if Resource.where(slug: existing_resource.slug).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Resource.slug_simple_starts_with(existing_resource.slug)
                                    .order(slug: :desc)
                                    .first
          existing_resource.slug += generate_offset(first_duplicate)
        end
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        existing_resource.resource_type = current_row_data['Type (Pick 1)']

        existing_resource.resource_topics = []
        topics = current_row_data['Topic (Multi-Select)'].split(',')
        topics.each do |topic|
          topic_name = topic.strip
          next if topic_name.blank?

          tag = Tag.find_by(slug: reslug_em(topic_name))
          tag = Tag.find_by(name: topic_name) if tag.nil?
          tag = Tag.new(name: topic_name, slug: reslug_em(topic_name)) if tag.nil?
          # Save the new tag to the database.
          tag.save!
          # Assign tag to the resource.
          unless existing_resource.tags.include?(tag.name)
            existing_resource.tags << tag.name
          end

          next unless DEFAULT_RESOURCE_TOPICS.include?(topic_name)

          resource_topic = ResourceTopic.find_by(name: topic_name)
          if resource_topic.nil?
            resource_topic = ResourceTopic.new(name: topic_name, slug: reslug_em(topic_name))
          end
          # Save the new resource topic to the database.
          resource_topic.save!
          # Assign resource topic to the resource.
          unless existing_resource.resource_topics.include?(resource_topic.name)
            existing_resource.resource_topics << resource_topic.name
          end
        end

        authors = current_row_data['Author'].split(';')
        authors.each do |author|
          author_name = author.strip
          next if author_name.blank?

          resource_author = Author.find_by(name: author_name)
          resource_author = Author.find_by(slug: reslug_em(author_name)) if resource_author.nil?
          resource_author = Author.new if resource_author.nil?

          resource_author.name = author_name
          resource_author.slug = reslug_em(author_name)

          avatar_api = 'https://ui-avatars.com/api/?name='
          avatar_params = '&background=2e3192&color=fff&format=svg'
          resource_author.picture = "#{avatar_api}#{resource_author.name.gsub(/\s+/, '+')}#{avatar_params}"

          existing_resource.authors << resource_author unless existing_resource.authors.include?(resource_author)
        end

        existing_resource.resource_link = cleanup_url(current_row_data['Link'])
        existing_resource.description = current_row_data['Description']

        # Link to an organization
        organization_name = current_row_data['Source']
        organization = Organization.find_by(name: organization_name)
        organization = Organization.find_by(slug: reslug_em(organization_name)) if organization.nil?
        if organization.nil? && !organization_name.blank?
          organization = Organization.new
          organization.name = organization_name
          organization.slug = reslug_em(organization_name)
          organization.save!
        end
        existing_resource.organization_id = organization.id unless organization.nil?

        existing_resource.countries = []
        country_name = current_row_data['Country/Region']
        unless country_name.nil? || country_name.blank?
          country = Country.find_by(name: country_name)
          unless country.nil?
            existing_resource.countries << country
          end
        end

        existing_resource.published_date = safe_parse_date(current_row_data['Publication Date'])

        existing_resource.save!
        successful_operation = true
      end

      if successful_operation
        puts "  Successfully created resource: #{existing_resource.id}:#{existing_resource.name}."
      end
    end

    tracking_task_finish(task_name)
  end

  desc 'Parse CGD website for resources.'
  task sync_cgd_website: :environment do
    task_name = 'Sync CDG Resources'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    # Fetch all resources from wordpress API
    current_page = 1
    cgd_base = 'https://www.cgdev.org/page/site-search'
    cgd_research_base = '?search_api_fulltext=data%20localization&sort_bef_combine=search_api_relevance_DESC'

    still_seeing_resources = true
    while still_seeing_resources
      cgd_page_query = "&page=#{current_page}"

      connection = Faraday.new(url: cgd_base)
      response = connection.get("#{cgd_research_base}#{cgd_page_query}")
      response_body = response.body

      puts "Response: #{response_body}."

      still_seeing_resources = false
    end
  end

  desc 'Parse data.org website for resources.'
  task sync_datadotorg_website: :environment do
  end

  def safe_parse_date(date_in_string_format)
    parsed_date = nil

    assumed_timezone = 'UTC'
    begin
      parsed_date = Date.parse("#{date_in_string_format} #{assumed_timezone}")
    rescue ArgumentError
      puts "  Unable to parse date using parse method."
    end

    # Return if we're getting a correct date object
    return parsed_date unless parsed_date.nil?

    begin
      parsed_date = Date.strptime("#{date_in_string_format} #{assumed_timezone}", '%Y')
    rescue ArgumentError
      puts "  Unable to parse date using strptime method."
    end

    puts "  Date parsing: '#{date_in_string_format}' ->  '#{parsed_date}'."

    parsed_date
  end
end
