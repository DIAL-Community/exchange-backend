# frozen_string_literal: true

require 'faraday'
require 'json'
require 'nokogiri'
require 'modules/slugger'
require 'modules/url_sanitizer'

namespace :gdpir_sync do
  desc 'Scrape the GDPIR website for products.'
  task sync_products: :environment do
    gdpir_dpi_url = 'https://www.dpi.global/globaldpi/dpicatedata'

    puts "Opening: #{gdpir_dpi_url}."
    response = Faraday.get(gdpir_dpi_url)
    puts "Response status: #{response.status}."
    break unless response.status == 200

    html_fragment = Nokogiri::HTML.fragment(response.body)

    # The structure for the DPI accordion is a bit strange.
    # accordion
    #   accordion-item
    #     accordion-header
    #     accordion-body
    #     accordion-item
    #       accordion-header
    #       accordion-body
    #     accordion-item
    #       accordion-header
    #       accordion-body
    #     accordion-item
    #       accordion-header
    #       accordion-body

    dpi_accordion_item = html_fragment.at_css('div.accordion div.accordion-item')
    # First header of the first item.
    dpi_header_title = dpi_accordion_item.at_css('h2.accordion-header').text.strip
    puts "Processing DPI Header title: #{dpi_header_title}."

    dpi_headers = dpi_accordion_item.css('div.accordion-item')
    dpi_headers.each do |dpi_header|
      dpi_header_title = dpi_header.css('h2.accordion-header').text.strip
      puts "Processing DPI Header title: #{dpi_header_title}."
    end
  end
end
