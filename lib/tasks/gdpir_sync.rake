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

    outer_dpi_accordion_item = html_fragment.at_css('div.accordion div.accordion-item')
    # First header of the first item.
    dpi_header_title = outer_dpi_accordion_item.at_css('h2.accordion-header').text.strip
    puts "Processing: #{dpi_header_title}."

    dpi_body = outer_dpi_accordion_item.at_css('div.accordion-body')
    dpi_body_links = dpi_body.css('a')
    dpi_body_links.each do |dpi_body_link|
      dpi_product_url = dpi_body_link.attr('href')
      dpi_product_logo_url = dpi_body_link.at_css('img')
      process_dpi_product(dpi_product_url, dpi_product_logo_url)
    end

    dpi_accordion_items = outer_dpi_accordion_item.css('div.accordion-item')
    dpi_accordion_items.each do |dpi_accordion_item|
      dpi_header_title = dpi_accordion_item.at_css('h2.accordion-header').text.strip
      puts "Processing: #{dpi_header_title}."

      dpi_body = dpi_accordion_item.at_css('div.accordion-body')
      dpi_body_links = dpi_body.css('a')
      dpi_body_links.each do |dpi_body_link|
        dpi_product_url = dpi_body_link.attr('href')
        dpi_product_logo_url = dpi_body_link.at_css('img')
        process_dpi_product(dpi_product_url, dpi_product_logo_url)
      end
    end
  end

  def process_dpi_product(dpi_product_url, dpi_product_logo_url)
    response = Faraday.get(dpi_product_url)
    puts "  Product url: #{dpi_product_url}."
    puts "    Response status: #{response.status}."
    return unless response.status == 200

    html_fragment = Nokogiri::HTML.fragment(response.body)
    dpi_product_title = html_fragment.at_css('h5').text.strip
    puts "    Processing: #{dpi_product_title}."

    name_products = Product.name_contains(dpi_product_title)
    desc_products = Product.joins(:product_descriptions)
                           .where('LOWER(product_descriptions.description) like LOWER(?)', "%#{dpi_product_title}%")
    alias_products = Product.where("LOWER(array_to_string(aliases,',')) like LOWER(?)", "%#{dpi_product_title}%")
    product = Product.find_by(id: (name_products.ids + desc_products.ids + alias_products.ids).uniq.first)

    # Skip if the product already exists and is manually updated already.
    return if !product.nil? && product.manual_update

    if product.nil?
      product = Product.new(
        name: dpi_product_title,
        slug: slug_em(dpi_product_title),
        website: cleanup_url(dpi_product_url)
      )
    end

    successful_operation = false
    ActiveRecord::Base.transaction do
      product.save

      description = ''
      containers = html_fragment.css('section#aadhaar-card > div.container-fluid')
      containers.each do |container|
        container_title_element = container.at_css('h3')
        container_title_element.xpath('//@*').remove
        puts "    Processing: #{container_title_element.text.strip}."
        description += <<~EOF
          #{container_title_element}
        EOF

        container_body_element = container_title_element.next_element
        next if container_body_element.nil?

        container_body_element.xpath('//@*').remove
        description += <<~EOF
          #{container_body_element}
        EOF
      end

      unless description.blank?
        product_description = ProductDescription.find_by(product_id: product.id, locale: I18n.locale)
        product_description = ProductDescription.new if product_description.nil?
        product_description.product_id = product.id
        product_description.locale = I18n.locale
        product_description.description = description
        product_description.save
      end

      unless dpi_product_logo_url.nil?
        faraday_downloader = Faraday.new do |builder|
          builder.adapter(Faraday.default_adapter)
        end
        response = faraday_downloader.get(dpi_product_logo_url.attr('src'))

        temp_file = Tempfile.new([product.slug, '.png'], binmode: true)
        begin
          temp_file.write(response.body)
          temp_file.close

          unless File.exist?(File.join('public', 'assets', 'products', "#{product.slug}.png"))
            # Maybe we can have system user in the future?
            uploader = User.find_by(username: 'nribeka')
            # Upload the logo file, the logo file is not in the filesystem yet.
            uploader = LogoUploader.new(product, "#{product.slug}.png", uploader)
            uploader.store!(temp_file)
          end
        rescue StandardError => e
          puts "  Unable to save logo for: #{product.name}. Error message: #{e.inspect}."
        ensure
          temp_file.unlink
        end
      end

      successful_operation = true
    end

    if successful_operation
      puts "GDPIR product, '#{product.name}', saved."
    end
  end
end
