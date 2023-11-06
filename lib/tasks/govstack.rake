# frozen_string_literal: true

namespace :govstack do
  desc 'Parse and process active procurements from the govstack website.'
  task sync_govstack_procurements: :environment do
    task_name = 'Sync GovStack RFP'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    govstack_origin = Origin.find_by(name: 'GovStack')
    if govstack_origin.nil?
      govstack_origin = Origin.new
      govstack_origin.name = 'GovStack'
      govstack_origin.slug = slug_em(govstack_origin.name)
      govstack_origin.description = <<-govstack_description
        GovStack offers governments with essential tools for digital services, including building block
        specifications, a sandbox for testing (upcoming), communities of practices, and more. GovStack
        also organizes forums for digital changemakers to network with each other and exchange their
        experiences on introducing eGovernment services through the CIO Digital Leaders Forum.
      govstack_description

      puts 'GovStack origin record created.' if govstack_origin.save!
    end

    govstack_url = 'https://www.govstack.global/govstack-procurement-activities/'
    govstack_response = Faraday.get(govstack_url)

    puts "GovStack response status: #{govstack_response.status}."
    break unless govstack_response.status == 200

    govstack_html = Nokogiri::HTML(govstack_response.body)

    # Find the header node
    header_node = govstack_html.xpath('//h2[contains(text(), "Request for Proposals")]').first
    break if header_node.nil?

    opportunity_nodelist = header_node.next_sibling.children
    opportunity_nodelist.each do |opportunity_node|
      opportunity_node_header = opportunity_node.search('h5').first
      next if opportunity_node_header.nil? || !opportunity_node_header.text.include?('Active')

      opportunity_name = opportunity_node_header.text.gsub('Active: ', '').strip
      opportunity_slug = slug_em(opportunity_name, 128)

      puts "Processing: #{opportunity_slug}."
      opportunity = Opportunity.name_and_slug_search(opportunity_name, opportunity_slug).first
      puts "Existing opportunity found: #{!opportunity.nil?}."
      next unless opportunity.nil?

      opportunity = Opportunity.new(name: opportunity_name, slug: opportunity_slug)

      start_date_paragraph, end_date_paragraph, link_paragraph = opportunity_node.search('p')

      parsed_start_date = Date.parse(start_date_paragraph.text)
      opportunity.opening_date = parsed_start_date

      parsed_end_date = Date.parse(end_date_paragraph.text)
      opportunity.closing_date = parsed_end_date

      link_href = link_paragraph.search('a').first.attr('href')
      opportunity.web_address = cleanup_url(link_href)

      opportunity.opportunity_type = Opportunity.opportunity_type_types[:OTHER]
      opportunity.opportunity_status = Opportunity.opportunity_status_types[:OPEN]

      opportunity.govstack_entity = true
      opportunity.origin = govstack_origin

      opportunity.description = <<-govstack_rfp_description
        <p>
          GovStack RFP pulled from
          <a
            href='//www.govstack.global/govstack-procurement-activities/'
            target='_blank'
            rel='noreferrer'
          >
            https://www.govstack.global/govstack-procurement-activities/
          </a>
        </p>
      govstack_rfp_description

      opportunity.contact_name = 'N/A'
      opportunity.contact_email = 'N/A'

      successful_operation = false
      ActiveRecord::Base.transaction do
        opportunity.save!
      end

      if successful_operation
        puts "Opportunity '#{opportunity.name}' record saved."
      end
    end

    tracking_task_finish(task_name)
  end
end
