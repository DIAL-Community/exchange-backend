# frozen_string_literal: true

require 'faraday'
require 'json'
require 'nokogiri'
require 'modules/slugger'
require 'modules/url_sanitizer'

namespace :gdpir_sync do
  desc 'Scrape the GDPIR website for products.'
  task sync_products: :environment do
    task_name = 'Sync GDPIR Products'
    tracking_task_setup(task_name, 'Preparing task tracker record.')
    tracking_task_start(task_name)

    gdpir_dpi_url = 'https://www.dpi.global/globaldpi/dpicatedata'

    gdpir_name = 'Global Digital Public Infrastructure Repository'
    gdpir_origin = Origin.find_by(slug: 'gdpir')
    gdpir_origin = Origin.find_by(slug: slug_em(gdpir_name)) if gdpir_origin.nil?
    if gdpir_origin.nil?
      gdpir_origin = Origin.new
    end

    gdpir_origin.name = gdpir_name
    gdpir_origin.slug = slug_em(gdpir_name)
    gdpir_origin.description = <<~DESCRIPTION
      The GDPIR is designed to be a resource for key lessons and knowledge available from G20
      members and guest countries, enabling easy discoverability. It is aimed at addressing
      the existing knowledge gap around the right practices to design, build, and deploy population
      scale DPI.
    DESCRIPTION

    puts 'GDPIR as origin is created.' if gdpir_origin.save!

    puts "Opening: #{gdpir_dpi_url}."
    response = Faraday.get(gdpir_dpi_url)
    puts "Response status: #{response.status}."
    break unless response.status == 200

    category_to_building_block_map = {
      'Payment' => 'Payments',
      'Data Exchange' => 'Information Mediator'
    }

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

    building_block = BuildingBlock.find_by(name: dpi_header_title)
    if building_block.nil?
      mapped_category = category_to_building_block_map[dpi_header_title]
      building_block = BuildingBlock.find_by(name: mapped_category)
    end
    puts "  Mapped to building block: #{building_block.name}." unless building_block.nil?

    dpi_body = outer_dpi_accordion_item.at_css('div.accordion-body')
    dpi_body_links = dpi_body.css('a')
    dpi_body_links.each do |dpi_body_link|
      dpi_product_url = dpi_body_link.attr('href')
      dpi_product_logo_url = dpi_body_link.at_css('img')
      process_dpi_product(dpi_product_url, dpi_product_logo_url, building_block)
    end

    dpi_accordion_items = outer_dpi_accordion_item.css('div.accordion-item')
    dpi_accordion_items.each do |dpi_accordion_item|
      dpi_header_title = dpi_accordion_item.at_css('h2.accordion-header').text.strip
      puts "Processing: #{dpi_header_title}."

      building_block = BuildingBlock.find_by(name: dpi_header_title)
      if building_block.nil?
        mapped_category = category_to_building_block_map[dpi_header_title]
        building_block = BuildingBlock.find_by(name: mapped_category)
      end
      puts "  Mapped to building block: #{building_block.name}." unless building_block.nil?

      dpi_body = dpi_accordion_item.at_css('div.accordion-body')
      dpi_body_links = dpi_body.css('a')
      dpi_body_links.each do |dpi_body_link|
        dpi_product_url = dpi_body_link.attr('href')
        dpi_product_logo_url = dpi_body_link.at_css('img')
        process_dpi_product(dpi_product_url, dpi_product_logo_url, building_block)
      end
    end

    # Next we process the countries where we can find each of the DPI.
    country_name_to_code_hash = {
      'Republic of Korea' => 'KR',
      'European Union' => 'N/A'
    }

    puts "------------------------------------"
    gdpir_country_url = 'https://www.dpi.global/globaldpi/allcountrydpi'
    puts "Opening country page: #{gdpir_country_url}."

    response = Faraday.get(gdpir_country_url)
    puts "Country page response status: #{response.status}."
    break unless response.status == 200

    html_fragment = Nokogiri::HTML.fragment(response.body)
    accordion_items = html_fragment.css('div.accordion-item')
    accordion_items.each do |accordion_item|
      accordion_header = accordion_item.at_css('h2.accordion-header')
      country_name = accordion_header.text.strip

      country_name_or_code = country_name
      if country_name_to_code_hash.key?(country_name)
        country_name_or_code = country_name_to_code_hash[country_name]
      end

      puts "Processing country name or code: #{country_name} -> #{country_name_or_code}."
      country = Country.find_by(name: country_name_or_code)
      country = Country.find_by(code: country_name_or_code) if country.nil?
      if country.nil?
        puts "  Unable to find country using name or code: #{country_name} -> #{country_name_or_code}."
        next
      end

      dpi_products = accordion_item.css('div.accordion-body a')
      dpi_products.each do |dpi_product|
        dpi_product_url = dpi_product.attr('href')
        process_dpi_product_country(dpi_product_url, country_name_or_code)
      end
    end

    tracking_task_finish(task_name)
  end

  def process_dpi_product_country(dpi_product_url, country_name_or_code)
    response = Faraday.get(dpi_product_url)
    puts "  Product url: #{dpi_product_url}."
    puts "    Response status: #{response.status}."
    return unless response.status == 200

    html_fragment = Nokogiri::HTML.fragment(response.body)
    dpi_product_title = html_fragment.at_css('h5').text.strip

    task_name = 'Sync GDPIR Products'
    tracking_task_log(task_name, "Processing country for: #{dpi_product_title}.")
    puts "    Processing country for: #{dpi_product_title}."

    name_products = Product.name_contains(dpi_product_title)
    desc_products = Product.joins(:product_descriptions)
                           .where('LOWER(product_descriptions.description) like LOWER(?)', "%#{dpi_product_title}%")
    alias_products = Product.where("LOWER(array_to_string(aliases,',')) like LOWER(?)", "%#{dpi_product_title}%")
    product = Product.find_by(id: (name_products.ids + desc_products.ids + alias_products.ids).uniq.first)

    country = Country.find_by(name: country_name_or_code)
    country = Country.find_by(code: country_name_or_code) if country.nil?
    product.countries << country unless product.countries.include?(country)

    if product.save
      puts "    Country #{country_name_or_code} added to product: #{product.name}."
    end
  end

  def process_dpi_product(dpi_product_url, dpi_product_logo_url, building_block)
    response = Faraday.get(dpi_product_url)
    puts "  Product url: #{dpi_product_url}."
    puts "    Response status: #{response.status}."
    return unless response.status == 200

    html_fragment = Nokogiri::HTML.fragment(response.body)
    dpi_product_title = html_fragment.at_css('h5').text.strip

    task_name = 'Sync GDPIR Products'
    tracking_task_log(task_name, "Processing: #{dpi_product_title}.")
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

    unless building_block.nil?
      product.building_blocks << building_block unless product.building_blocks.include?(building_block)
    end

    gdpir_origin = Origin.find_by(slug: 'gdpir')
    product.origins << gdpir_origin unless product.origins.include?(gdpir_origin) || gdpir_origin.nil?

    # Processing website and repository section. This section usually have h5 as the title.
    # Expected structure:
    # <section>
    #   <div>
    #     <h5>Github</h5>
    #     <ol>
    #       <li>
    #         <a>Link to github</a>
    #       </li>
    #     </ol>
    #   </div>
    #   <div>
    #     <h5>Website</h5>
    #     <ol>
    #       <li>
    #         <a>Link to website</a>
    #       </li>
    #     </ol>
    #   </div>
    # </section>
    # Or different variation of the expected structure:
    # <section>
    #   <div>
    #     <h5>Website</h5>
    #     <ol>
    #       <li>
    #         <a>Link to website</a>
    #       </li>
    #     </ol>
    #   </div>
    # </section>

    section_container = html_fragment.at_css('section')
    repository_section_headers = section_container.css('section h5')
    repository_section_headers.each do |repository_section_header|
      next if repository_section_header.nil?

      # Processing next element, which is the hr element.
      repository_hr_element = repository_section_header.next_element

      repository_list_element = repository_hr_element.next_element
      repository_section_body = repository_list_element.at_css('li a')

      puts "    Processing: #{repository_section_header.text.strip.gsub(':', '')}."
      if repository_section_header.text.include?('Website') ||
        repository_section_header.text.include?('Link')
        product.website = cleanup_url(repository_section_body.attr('href'))
      elsif repository_section_header.text.include?('Github') ||
        repository_section_header.text.include?('Repository')

        product_repository_name = "#{product.name} Repository"
        product_repository = ProductRepository.find_by(slug: slug_em(product_repository_name))
        if product_repository.nil?
          product_repository = ProductRepository.new(slug: slug_em(product_repository_name))

          product_repositories = ProductRepository.where(slug: product_repository.slug)
          unless product_repositories.empty?
            first_duplicate = ProductRepository.slug_simple_starts_with(product_repository.slug)
                                               .order(slug: :desc)
                                               .first
            product_repository.slug += generate_offset(first_duplicate).to_s
          end
        end

        product_repository.name = product_repository_name
        product_repository.absolute_url = cleanup_url(repository_section_body.attr('href'))
        product_repository.description = "Repository for #{product.name}."
        product_repository.main_repository = false

        product.product_repositories << product_repository
      end
    end

    successful_operation = false
    ActiveRecord::Base.transaction do
      product.save

      description = ''
      section_container = html_fragment.at_css('section')
      section_container_children = section_container.children

      section_container_children.each do |container|
        next if container.name != 'div'

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

      # Processing section with image. This section usually have h1 as the title.
      # Expected structure:
      # <section>
      #   <h1>Architecture</h1>
      #   <img src="image_source" width="70%" height="70%" alt="Title" />
      # </section>
      other_sections = section_container.css('section h1')
      other_sections.each do |other_section|
        puts "    Processing: #{other_section.text.strip}."

        image_element = other_section.next_element
        image_source = image_element.attr('src')
        puts "      Image source: #{image_source}."

        description += <<~EOF
          <h3>#{other_section.text.strip}</h3>
          <img src="#{image_source}" width="70%" height="70%" alt="#{other_section.text.strip}" />
        EOF
      end

      # Processing contact section. This section usually have h3 as the title.
      # Expected structure:
      # <section>
      #   <h3>Contact Us</h3>
      #   <ul>
      #     <li>
      #       <b>Name of the contact</b>
      #       <span>Title of the contact</span>
      #     </li>
      #     <li>
      #       <span>Email of the contact</span>
      #     </li>
      #    </ul>
      # </section>
      # Or different variation of the expected structure:
      # <section>
      #   <h3>Contact Us</h3>
      #   <ul>
      #     <li>
      #       <span>Email of the contact</span>
      #     </li>
      #    </ul>
      # </section>
      contact_section = section_container.at_css('section h3')
      unless contact_section.nil?
        puts "    Processing: #{contact_section.text.strip}."
        description += <<~EOF
          <h3>#{contact_section.text.strip}</h3>
        EOF

        contact_section_body = contact_section.next_element
        contact_section_body_elements = contact_section_body.css('li')
        contact_section_body_elements.each do |contact_section_body_element|
          name_element = contact_section_body_element.at_css('b')
          if name_element.nil?
            description += <<~EOF
              <div>#{contact_section_body_element.text.strip}</div>
            EOF
          else
            description += <<~EOF
              <div>#{name_element.text.strip}</div>
            EOF

            title_element = name_element.next_element
            if title_element.nil?
              puts "    Skipping processing: #{name_element}."
              next
            end

            description += <<~EOF
              <div>#{title_element.text.strip}</div>
            EOF
          end
        end
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
