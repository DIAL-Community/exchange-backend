# frozen_string_literal: true

require 'faraday'
require 'json'
require 'nokogiri'
require 'tempfile'
require 'modules/slugger'

namespace :opportunities_sync do
  desc 'Sync RFP data from Leverist.'
  task sync_leverist: :environment do
    task_name = 'Sync Leverist RFP'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    # page_query = ''
    page_query = '?industries=JZmYlQ31enoN'
    base_leverist_url = 'https://api.leverist.de/frontend/opportunities'

    leverist_sector_file = File.read('utils/leverist_sector.json')
    leverist_sector_mapping = JSON.parse(leverist_sector_file)

    loop do
      puts "Opening: #{base_leverist_url}#{page_query}."
      response = Faraday.get("#{base_leverist_url}#{page_query}")
      puts "Response status: #{response.status}."
      break unless response.status == 200

      leverist_data = JSON.parse(response.body)
      process_leverist_data(leverist_data, leverist_sector_mapping)

      pagination_info = leverist_data['meta']['pagination']
      pagination_links = pagination_info['links']

      puts "***********"
      puts("Pagination info: #{pagination_info.inspect}")

      page_query = ''
      if pagination_links.is_a?(Hash) && pagination_links.key?('next')
        page_query = pagination_links['next'][1..-1]
      end
      break if page_query.blank?
    end

    tracking_task_finish(task_name)
  end

  def process_leverist_data(leverist_data, leverist_sector_mapping)
    task_name = 'Sync Leverist RFP'
    opportunity_data = leverist_data['data']
    opportunity_data.each do |opportunity_structure|
      puts '----------'
      puts "Reading opportunity: #{opportunity_structure['title']}."
      tracking_task_log(task_name, "Parsing: #{opportunity_structure['title']}.")
      create_opportunity_record(opportunity_structure, leverist_sector_mapping)
    end
  end

  def node_is_blank?(node)
    (node.text? && node.content.strip == '') || (node.element? && node.name == 'br')
  end

  def all_children_are_blank?(node)
    node.children.all? { |child| node_is_blank?(child) }
  end

  def create_opportunity_record(opportunity_structure, leverist_sector_mapping)
    opportunity_name = opportunity_structure['title']
    opportunity_slug = reslug_em(opportunity_structure['title'])
    opportunity = Opportunity.name_and_slug_search(opportunity_name, opportunity_slug).first
    if opportunity.nil?
      opportunity = Opportunity.new(name: opportunity_name)
      opportunity.slug = reslug_em(opportunity_structure['title'])

      if Opportunity.where(slug: opportunity.slug).count.positive?
        # Check if we need to add _dup to the slug.
        first_duplicate = Opportunity.slug_simple_starts_with(opportunity.slug)
                                     .order(slug: :desc)
                                     .first
        opportunity.slug += generate_offset(first_duplicate)
      end
    end

    # Don'r re-slug opportunity name
    opportunity.name = opportunity_name

    unless opportunity_structure['slug'].nil?
      opportunity.web_address = "app.leverist.de/en/opportunities/#{opportunity_structure['slug']}"
    end

    description_fragment = Nokogiri::HTML.fragment(opportunity_structure['description'])
    # Strip empty p tags.
    description_fragment.css('p')
                        .find_all { |p| all_children_are_blank?(p) }
                        .each(&:remove)
    opportunity.description = description_fragment.to_html

    # Adding tender information to description.
    unless opportunity_structure['tender_information'].blank?
      tender_information_header = '<p><strong>Tender Information</strong></p>'
      opportunity.description += Nokogiri::HTML.fragment(tender_information_header).to_html

      tender_information = Nokogiri::HTML.fragment(opportunity_structure['tender_information'])
      tender_fragment = Nokogiri::HTML.fragment(tender_information)
      # Strip dangling br tag.
      tender_fragment.css('br').each { |br| br.replace('') }
      # Strip empty p tags.
      tender_fragment.css('p')
                     .find_all { |p| all_children_are_blank?(p) }
                     .each(&:remove)
      opportunity.description += tender_fragment.to_html
    end

    # Adding target audience information to description.
    unless opportunity_structure['target_audience'].blank?
      target_audience_header = '<p><strong>Target Audience</strong></p>'
      opportunity.description += Nokogiri::HTML.fragment(target_audience_header).to_html

      target_audience = Nokogiri::HTML.fragment(opportunity_structure['target_audience'])
      target_audience = Nokogiri::HTML.fragment(target_audience)
      # Strip empty p tags.
      target_audience.css('p')
                     .find_all { |p| all_children_are_blank?(p) }
                     .each(&:remove)
      opportunity.description += target_audience.to_html
    end

    opportunity.contact_name = 'N/A'
    opportunity.contact_email = 'N/A'
    personnel_data = opportunity_structure['personnel']['data']
    unless personnel_data.empty?
      first_personel, _others = personnel_data
      opportunity.contact_name = first_personel['name']
    end

    # Process type of the record.
    opportunity_type = Opportunity.opportunity_type_types[:OTHER]
    case opportunity_structure['type']['key']
    when 'innovation_challenge'
      opportunity_type = Opportunity.opportunity_type_types[:INNOVATION]
    when 'tender'
      opportunity_type = Opportunity.opportunity_type_types[:TENDER]
    when 'bid'
      opportunity_type = Opportunity.opportunity_type_types[:BID]
    else
      puts "  Other type: #{opportunity_structure['type']['key']}"
    end
    opportunity.opportunity_type = opportunity_type

    # Process status of the record.
    opportunity_status = Opportunity.opportunity_status_types[:CLOSED]
    case opportunity_structure['status']['key']
    when 'finished', 'on_execution'
      opportunity_status = Opportunity.opportunity_status_types[:CLOSED]
    when 'open_for_proposals'
      opportunity_status = Opportunity.opportunity_status_types[:OPEN]
    when 'upcoming'
      opportunity_status = Opportunity.opportunity_status_types[:UPCOMING]
    else
      puts "  Other status: #{opportunity_structure['status']['key']}"
    end
    opportunity.opportunity_status = opportunity_status

    # Process date information.
    unless opportunity_structure['deadline_current_status'].nil?
      opportunity.closing_date = Time.iso8601(opportunity_structure['deadline_current_status'])
    end

    opportunity.origin = Origin.find_by(name: 'GIZ')

    opportunity_countries = []
    country_data = opportunity_structure['countries']['data']
    unless country_data.empty?
      country_data.each do |country_structure|
        country = Country.find_by(code: country_structure['iso_code'])
        opportunity_countries << country unless country.nil?
        puts "  Country: Unable to find '#{country_structure['iso_code']}'." if country.nil?
      end
    end
    opportunity.countries = opportunity_countries

    opportunity_sectors = []
    opportunity_organizations = []
    sector_data = opportunity_structure['industries']['data']
    unless sector_data.empty?
      sector_data.each do |sector_structure|
        mapped_sector = leverist_sector_mapping[sector_structure['name']]
        puts "  Sector: '#{sector_structure['name']}' mapped to -> '#{mapped_sector}'."

        sector = Sector.find_by(name: mapped_sector, locale: I18n.locale)
        unless sector.nil?
          multi_locale_sectors = Sector.where(slug: sector.slug)
          opportunity_sectors += multi_locale_sectors unless multi_locale_sectors.empty?
        end

        # Skip if industry don't have partner data.
        next if sector_structure['partners'].nil?

        partner_data = sector_structure['partners']['data']
        # Skipt if partner data is empty.
        next if partner_data.empty?

        partner_data.each do |partner_structure|
          organization = Organization.find_by(name: partner_structure['name'])
          opportunity_organizations << organization unless organization.nil?

          next unless organization.nil?

          puts "  Organization: Unable to find '#{partner_structure['name']}'."
          website = partner_structure['web']
          description = partner_structure['description']
          organization_name = partner_structure['name']

          candidate_params = { name: organization_name, website:, description: }
          candidate_params[:slug] = reslug_em(organization_name)
          candidate_organization = CandidateOrganization.find_by(slug: candidate_params[:slug])
          unless candidate_organization.nil?
            puts "    Skipping, existing candidate organization record found."
            next
          end

          candidate_organizations = CandidateOrganization.where(slug: candidate_params[:slug])
          unless candidate_organizations.empty?
            first_duplicate = CandidateOrganization.slug_simple_starts_with(candidate_params[:slug])
                                                   .order(slug: :desc)
                                                   .first
            candidate_params[:slug] = candidate_params[:slug] + generate_offset(first_duplicate).to_s
          end
          candidate_organization = CandidateOrganization.new(candidate_params)
          if candidate_organization.save
            puts "    Saving '#{partner_structure['name']}' as candidate organization."
          end
        end
      end
    end
    opportunity.sectors = opportunity_sectors.uniq
    opportunity.organizations = opportunity_organizations

    successful_operation = false
    ActiveRecord::Base.transaction do
      opportunity.save!

      unless opportunity_structure['picture'].nil?
        logo_data = opportunity_structure['picture']['data']
        logo_path_file = logo_data['original_file']

        faraday_downloader = Faraday.new do |builder|
          builder.adapter(Faraday.default_adapter)
        end
        response = faraday_downloader.get(logo_path_file)

        temp_file = Tempfile.new([opportunity.slug, ".#{logo_data['extension']}"], binmode: true)
        begin
          temp_file.write(response.body)
          temp_file.close

          # TODO: Skipping if we already have the logo file. This would mean we could have stale logo.
          # If we don't do this check, the scheduled task will bombard our mailbox with notification.
          unless File.exist?(File.join('public', 'assets', 'opportunities', "#{opportunity.slug}.png"))
            # Maybe we can have system user in the future?
            uploader = User.find_by(username: 'nribeka')
            file_extension = logo_data['extension']
            # Upload the logo file because they're not in the filesystem.
            uploader = LogoUploader.new(opportunity, "#{opportunity.slug}.#{file_extension}", uploader)
            uploader.store!(temp_file)
          end
        rescue StandardError => e
          puts "  Unable to save logo for: #{opportunity.name}. Error message: #{e.inspect}."
        ensure
          temp_file.unlink
        end
      end

      successful_operation = true
    end

    if successful_operation
      puts "Opportunity '#{opportunity.name}' record saved."
    end
  end

  desc 'Sync RFP data from UNGM.'
  task sync_ungm: :environment do
    task_name = 'Sync UNGM RFP'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    ungm_origin = Origin.find_by(name: 'United Nations Global Marketplace')
    if ungm_origin.nil?
      ungm_origin = Origin.new
      ungm_origin.name = 'United Nations Global Marketplace'
      ungm_origin.slug = reslug_em('United Nations Global Marketplace', 64)
      ungm_origin.description = %{
        The United Nations Global Marketplace (UNGM) is the official procurement portal of the United Nations
        System. The UNGM portal brings together UN procurement staff and suppliers interested in doing business
        with the United Nations.
      }.strip

      puts 'United Nations Global Marketplace as origin is created.' if ungm_origin.save!
    end

    still_seeing_notices = true
    connection = Faraday.new(url: 'https://www.ungm.org/Public/Notice/Search')

    current_page = 0
    while still_seeing_notices
      response = connection.post do |request|
        request.headers['Accept'] = 'application/json'
        request.headers['Content-Type'] = 'application/json'
        request.body = %{
          {
            "PageIndex": #{current_page},
            "PageSize": 15,
            "Title": "",
            "Description": "",
            "Reference": "",
            "PublishedFrom": "",
            "PublishedTo": "#{Date.today.strftime('%d-%b-%Y')}",
            "DeadlineFrom": "#{Date.today.strftime('%d-%b-%Y')}",
            "DeadlineTo": "",
            "Countries": [],
            "Agencies": [],
            "UNSPSCs": [
                107373,
                145204
            ],
            "NoticeTypes": [],
            "SortField": "DatePublished",
            "SortAscending": false,
            "isPicker": false,
            "IsSustainable": false,
            "NoticeDisplayType": null,
            "NoticeSearchTotalLabelId": "noticeSearchTotal",
            "TypeOfCompetitions": []
          }
        }
      end

      puts "Response status: #{response.status}."

      if response.status == 200
        html_response = response.body
        parsed_response = Nokogiri::HTML(html_response)

        # We're only interested in the notice divs, not the script tag.
        notice_divs = parsed_response.css('div.notice-table')

        puts "Seeing #{notice_divs.count} notices."
        if notice_divs.count.zero?
          still_seeing_notices = false
        else
          notice_divs.each do |notice_div|
            process_ungm_notice(notice_div)
          end
        end
      end

      current_page += 1
    end

    tracking_task_finish(task_name)
  end

  def process_ungm_notice(notice_div)
    base_ungm_notice_url = 'https://www.ungm.org/Public/Notice/'

    notice_id = notice_div.attribute('data-noticeid')
    response = Faraday.get("#{base_ungm_notice_url}#{notice_id}")

    html_response = response.body
    parsed_response = Nokogiri::HTML(html_response)

    puts "****** Processing notice: #{notice_id} ******"

    base_info_div, background_info_div, contact_info_div = parsed_response.css('.ungm-list-item.ungm-background')
    notice_title = base_info_div.css('span.title').text.strip
    puts "  Notice title: #{notice_title}"

    opportunity_name = notice_title
    opportunity_slug = reslug_em(notice_title)
    opportunity = Opportunity.name_and_slug_search(opportunity_name, opportunity_slug).first
    if opportunity.nil?
      opportunity = Opportunity.new(name: opportunity_name, slug: opportunity_slug)
      if Opportunity.where(slug: opportunity.slug).count.positive?
        # Check if we need to add _dup to the slug.
        first_duplicate = Opportunity.slug_simple_starts_with(opportunity.slug)
                                     .order(slug: :desc)
                                     .first
        opportunity.slug += generate_offset(first_duplicate)
      end
    end

    # Set the web address for the opportunity pointing directly to the notice.
    opportunity.web_address = "#{base_ungm_notice_url}#{notice_id}".gsub('https://', '').gsub('http://', '')

    # Set the origin for the opportunity to United Nations Global Marketplace.
    opportunity.origin = Origin.find_by(name: 'United Nations Global Marketplace')

    base_info_values = base_info_div.css('span.value')
    if !base_info_values.nil? && !base_info_values.text.strip.empty?
      base_details = base_info_div.css('span.label')
      base_details.each do |base_detail|
        if base_detail.text.strip.downcase == 'deadline on:'
          date_format = "%d-%b-%Y %H:%M"
          opportunity.closing_date = Time.strptime(base_detail.next_element.text.strip, date_format)
          puts "  Setting up closing date: '#{base_detail.next_element.text.strip}'."
        elsif base_detail.text.strip.downcase == 'beneficiary countries:'
          opportunity.countries = []
          country = Country.find_by(name: base_detail.next_element.text.strip)
          opportunity.countries << country unless country.nil?
          puts "  Setting up country: '#{base_detail.next_element.text.strip}'."
        end
      end
    end

    opportunity_type = Opportunity.opportunity_type_types[:TENDER]
    opportunity.opportunity_type = opportunity_type

    opportunity_status = Opportunity.opportunity_status_types[:OPEN]
    opportunity.opportunity_status = opportunity_status

    contact_email = 'N/A'
    contact_last_name = 'N/A'
    contact_first_name = 'N/A'
    if contact_info_div.css('span.value').nil? || contact_info_div.css('span.value').text.strip.empty?
      opportunity.contact_email = contact_info_div.css('span.title').text.strip
      opportunity.contact_name = 'N/A'
    else
      contact_details = contact_info_div.css('.contactDetails').css('span.label')
      contact_details.each do |contact_detail|
        if contact_detail.text.strip.downcase == 'email'
          contact_email = contact_detail.next_element.text.strip
        elsif contact_detail.text.strip.downcase == 'surname'
          contact_last_name = contact_detail.next_element.text.strip
        elsif contact_detail.text.strip.downcase == 'first_name'
          contact_first_name = contact_detail.next_element.text.strip
        end
      end

      opportunity.contact_email = contact_email
      opportunity.contact_name = "#{contact_first_name} #{contact_last_name}"
    end

    background_div = background_info_div.css('div.title ~ *')
    opportunity.description = background_div.inner_html

    successful_operation = false
    ActiveRecord::Base.transaction do
      opportunity.save!

      successful_operation = true
    end

    if successful_operation
      puts "  RFP: '#{opportunity.name}' saved."
    end
  end
end
