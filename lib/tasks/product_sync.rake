# frozen_string_literal: true

require 'modules/slugger'

namespace :product_sync do
  desc 'Sync Digital Square implementation countries.'
  task sync_digital_square_implementation: :environment do
    country = Country.find_by(name: 'United States')
    country&.update(name: 'United States of America')

    country = Country.find_by(name: 'Niue')
    if country.nil?
      country = Country.new(
        name: 'Niue',
        slug: slug_em('Niue'),
        code: 'NU',
        code_longer: 'NIU',
        latitude: -19.053889,
        longitude: -169.920000
      )
      if country.save
        puts "Country 'Niue' created."
      end
    end

    country = Country.find_by(name: 'Cook Islands')
    if country.nil?
      country = Country.new(
        name: 'Cook Islands',
        slug: slug_em('Cook Islands'),
        code: 'CK',
        code_longer: 'COK',
        latitude: -21.200000,
        longitude: -159.766667
      )
      if country.save
        puts "Country 'Cook Islands' created."
      end
    end

    country_name_to_code_hash = {
      'United Kingdom of Great Britain and Northern Ireland' => 'GB',
      'Turkey' => 'TR',
      'Russian Federation' => 'RU',
      'Republic of the Congo' => 'CD',
      'Republic of Moldova' => 'MD',
      'Republic of Korea' => 'KR',
      'Myanmar' => 'MM',
      'Micronesia' => 'FM',
      'Laos' => 'LA',
      'Gambia' => 'GM',
      "Democratic People's Republic of Korea" => 'KP',
      'Czech Republic' => 'CZ',
      "Cote d'Ivoire" => 'CI',
      'Brunei' => 'BN',
      'Bolivia' => 'BO'
    }

    implementation_entries = CSV.parse(File.read('./data/digital-square-implementations.csv'), headers: true)
    implementation_entries.each do |implementation_entry|
      # Countries of Implementation -> Country name
      country_name = implementation_entry[0]
      puts "Processing country name: #{country_name}."

      country = Country.find_by(name: country_name)
      if country.nil?
        country_code = country_name_to_code_hash[country_name]
        puts "  Searching with country code: #{country_code}."
        country = Country.find_by(code: country_code)
      end

      puts "  Setting up implementation country: #{country.name}."

      # List with Line Breaks -> Product names separated by line breaks
      product_names = implementation_entry[1]
      product_names.lines.each do |product_name|
        name_param = product_name.strip.gsub(/[^\(\)a-z0-9\s]/i, '')

        name_products = Product.name_contains(name_param)
        desc_products = Product.joins(:product_descriptions)
                               .where('LOWER(product_descriptions.description) like LOWER(?)', "%#{name_param}%")
        alias_products = Product.where("LOWER(array_to_string(aliases,',')) like LOWER(?)", "%#{name_param}%")

        product = Product.find_by(id: (name_products.ids + desc_products.ids + alias_products.ids).uniq.first)
        if product.nil?
          puts "  Product #{product_name} not found. Skipping."
          next
        end

        product.countries << country unless product.countries.include?(country)

        if product.save
          puts "  Product #{product.name} updated."
        end
      end
    end
  end
end
