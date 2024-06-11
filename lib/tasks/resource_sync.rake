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
    resource.published_date = Date.strptime(post_structure['date_gmt'])

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
            if tag.nil?
              tag = Tag.find_by(name: tag_name)
            end

            if tag.nil?
              tag = Tag.new(name: tag_name, slug: reslug_em(tag_name))
            end

            # Save the new resource topic to the database.
            tag.save!

            resource_tags << tag.name

            next unless DEFAULT_RESOURCE_TOPICS.include?(tag_name)

            resource_topic = ResourceTopic.find_by(name: tag_name)
            resource_topics << resource_topic.name unless resource_topic.nil?
          end
        end

        tag_current_page += 1
      end
      resource.tags = resource_tags
      resource.resource_topics = resource_topics

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
        resource_author = Author.new if resource_author.nil?

        resource_author.name = author_href_response_body['name']
        resource_author.slug = reslug_em(author_href_response_body['name'])
        avatar_api = 'https://ui-avatars.com/api/?name='
        avatar_params = '&background=2e3192&color=fff&format=svg'
        resource_author.picture = "#{avatar_api}#{resource_author.name.gsub(/\s+/, '+')}#{avatar_params}"

        resource.authors << resource_author
      end

      source_organization = Organization.find_by(slug: 'digital-impact-alliance')
      unless source_organization.nil?
        resource.organization = source_organization
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
  end
end
