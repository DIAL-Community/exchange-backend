# frozen_string_literal: true

require 'modules/slugger'
require 'modules/track'

namespace :geocode do
  desc 'Geocode to find lattitude and longitude of addresses.'

  task :provinces, %i[path_to_provinces_file country_code] => :environment do |_, params|
    params.with_defaults(country_code: 'USA')
    country = Country.find_by(code: params[:country_code])

    puts("Reading provinces from: #{params[:path_to_provinces_file]}")
    province_string = File.read(params[:path_to_provinces_file])
    addresses = build_provinces(province_string, country)

    puts("Geocoding: #{addresses[:records].length} provinces!")
    auth_token = authenticate_user
    response = geocode(addresses, params[:country_code], auth_token)

    province_data = JSON.parse(response.body)

    province_data['locations'].each do |province|
      province_record = Province.new
      province_record.name = province['attributes']['Region']
      province_record.slug = reslug_em(province_record.name)
      province_record.country_id = country.id
      province_record.latitude = province['location']['x']
      province_record.longitude = province['location']['y']

      puts("Saving province: #{province_record.name}.") if province_record.save!
    end
  end

  task :districts, %i[path_to_districts_file country_code] => :environment do |_, params|
    params.with_defaults(country_code: 'USA')
    country = Country.find_by(code: params[:country_code])

    puts("Reading districts from: #{params[:path_to_districts_file]}")
    district_string = File.read(params[:path_to_districts_file])
    addresses = build_districts(district_string, country)

    puts("Geocoding: #{addresses[:records].length} districts!")
    auth_token = authenticate_user
    response = geocode(addresses, params[:country_code], auth_token)

    province_data = JSON.parse(response.body)

    province_data['locations'].each do |province|
      province_record = District.new
      province_record.name = province['attributes']['Subregion']
      province_record.slug = reslug_em(province_record.name)
      province_record.country_id = country.id
      province_record.latitude = province['location']['x']
      province_record.longitude = province['location']['y']

      puts("Saving province: #{province_record.name}.") if province_record.save!
    end
  end

  task :load_countries, %i[path_to_countries_file path_to_iban_file] => :environment do |_, params|
    countries = CSV.parse(File.read(params[:path_to_countries_file]), headers: true)
    countries.each do |country|
      country_record = Country.new
      country_record.name = country[3].strip
      country_record.code = country[0].strip
      # Hack to prevent error on initial load
      country_record.code_longer = ''
      country_record.slug = reslug_em(country_record.code)

      country_record.latitude = country[1].to_f
      country_record.longitude = country[2].to_f

      puts("Saving country: #{country_record.name}.") if country_record.save!
    end

    countries_iban = CSV.parse(File.read(params[:path_to_iban_file]), headers: true, col_sep: "\t")
    countries_iban.each do |country_iban|
      country_record = Country.find_by(code: country_iban[1].strip)
      if country_record.nil?
        puts "Skipping nil country for: #{country_iban[1].strip}."
        next
      end

      country_record.code_longer = country_iban[2].strip
      country_record.aliases << country_record.name
      country_record.name = country_iban[0]

      puts("Saving 3 letters country code for: #{country_record.name}.") if country_record.save!
    end
  end

  task :migrate_aggregator_capabilities_to_country, [] => :environment do
    task_name = 'Migrate Aggregator Country'
    tracking_task_start(task_name)

    google_auth_key = Rails.application.credentials.google_api_key
    AggregatorCapability.all.each do |aggregator|
      next unless aggregator.country_id.nil?

      country_name = aggregator.country_name
      country = Country.find_by(name: country_name)
      if country.nil?
        country = find_country(country_name, google_auth_key)
        if country.nil?
          puts "Unable to find country for #{aggregator.aggregator_id} -> #{country_name}."
          next
        end
      end

      aggregator.country_id = country.id
      puts "Adding country for aggregator: #{aggregator.aggregator_id}  to -> #{country.name}." if aggregator.save!
    end
    tracking_task_finish(task_name)
  end

  task :migrate_operator_services_to_country, [] => :environment do
    task_name = 'Migrate Operator Country'
    tracking_task_start(task_name)

    google_auth_key = Rails.application.credentials.google_api_key
    OperatorService.all.each do |operator|
      next unless operator.country_id.nil?

      location_id = operator.locations_id
      location = Location.find_by(id: location_id)
      if location.nil?
        puts "Unable to find location for #{operator.name} -> #{location_id}."
        next
      end

      country = Country.find_by(name: location.name)
      if country.nil?
        country = find_country(location.name, google_auth_key)
        if country.nil?
          puts "Unable to find country for #{operator.name} -> #{location.name}."
          next
        end
      end

      operator.country_id = country.id
      operator.country_name = country.name
      puts "Adding country for operator: #{operator.name} to -> #{country.name}." if operator.save!
    end
    tracking_task_finish(task_name)
  end

  task :migrate_projects_locations_with_google, [] => :environment do
    task_name = 'Migrate Project Country'
    tracking_task_start(task_name)

    google_auth_key = Rails.application.credentials.google_api_key
    Project.all.each do |project|
      puts "Processing #{project.name} ..."
      project.projects_locations.each do |project_location|
        if project_location.migrated
          puts 'Location already migrated. Skipping!'
          next
        end

        # Location is a country, change the reference to countries table.
        location = Location.find_by(id: project_location.location_id)
        if location.nil? || location.location_type != 'country'
          puts "Skipping unresolved country: #{location.name}."
          next
        end

        country = find_country(location.name, google_auth_key)
        if country.nil?
          puts "Skipping country without geocoded data: #{location.name}."
          next
        end

        countries = project.countries.where(id: country.id)
        project.countries.push(country) if countries.empty?
        project_location.migrated = true
        project_location.migrated_date = Time.now
        puts "Location marked as migrated: #{project_location.location_id}." if project_location.save!
      end
    end
    tracking_task_finish(task_name)
  end

  task :migrate_organizations_locations_with_google, [] => :environment do
    task_name = 'Migrate Organization Country'
    tracking_task_start(task_name)

    google_auth_key = Rails.application.credentials.google_api_key
    Organization.all.each do |organization|
      puts "Processing #{organization.name} ..."
      organization.organizations_locations.each do |organization_location|
        if organization_location.migrated
          puts 'Location already migrated. Skipping!'
          next
        end

        # Location is a country, change the reference to countries table.
        location = Location.find_by(id: organization_location.location_id)
        if location.location_type == 'country'
          country = find_country(location.name, google_auth_key)
          unless country.nil?
            countries = organization.countries.where(id: country.id)
            organization.countries.push(country) if countries.empty?
            organization_location.migrated = true
            organization_location.migrated_date = Time.now
            puts "Location marked as migrated: #{organization_location.location_id}." if organization_location.save!
          end
          next
        end

        # Location is a point:
        # * Reverse geocode to normalize the point
        # * Update using reverse geocode values
        # * Update reference to the state & countries

        office_data = {}

        geocode_data = JSON.parse(reverse_geocode_with_google(location, google_auth_key))
        geocode_results = geocode_data['results']
        geocode_results.each do |geocode_result|
          geocode_result['address_components'].each do |address_component|
            if address_component['types'].include?('locality') ||
               address_component['types'].include?('postal_town')
              office_data['city'] = address_component['long_name']
            elsif address_component['types'].include?('administrative_area_level_2')
              office_data['subprovince'] = address_component['long_name']
            elsif address_component['types'].include?('administrative_area_level_1')
              office_data['province'] = address_component['long_name']
            elsif address_component['types'].include?('country')
              office_data['country_code'] = address_component['short_name']
            end
          end
        end

        office = Office.new
        office.organization_id = organization.id

        country_code = office_data['country_code']
        unless office_data['country_code'].blank?
          country = find_country(country_code, google_auth_key)
          office.country_id = country.id
        end

        province_name = office_data['province']
        unless office_data['province'].blank? || office_data['country_code'].blank?
          province = find_province(province_name, country_code, google_auth_key)
          office.province_id = province.id
        end

        city_name = office_data['city']
        unless office_data['city'].blank? || office_data['province'].blank? || office_data['country_code'].blank?
          city = find_city(city_name, province_name, country_code, google_auth_key)

          office.city = city.name

          office.latitude = city.latitude
          office.longitude = city.longitude
        end

        if office_data['city'].blank? || office_data['province'].blank? || office_data['country_code'].blank?
          office.latitude = location[:points][0].x
          office.longitude = location[:points][0].y
          office_data['city'].blank? ? office.city = 'Unknown' : office.city = office_data['city']
        end

        address = "#{city_name}, #{province_name}, #{country_code}"
        office.name = address
        office.slug = reslug_em("#{organization.name} #{office.name}")

        if Office.find_by(slug: office.slug).nil?
          if office.save!
            puts "Saving office data for: #{office.name} -> #{office.slug}."
            organization_location.migrated = true
            organization_location.migrated_date = Time.now
            puts "Location marked as migrated: #{organization_location.location_id}." if organization_location.save!
          end
        else
          puts "Office already in database: #{office.slug}."
          organization_location.migrated = true
          organization_location.migrated_date = Time.now
          puts "Location marked as migrated: #{organization_location.location_id}." if organization_location.save!
        end
      end
      puts '------------------------------------------'
    end
    tracking_task_finish(task_name)
  end

  def find_country(country_code_or_name, google_auth_key)
    return if country_code_or_name.blank?

    puts "Processing country: #{country_code_or_name}."
    country_code_or_name = 'Curaço' if country_code_or_name == 'Curacao'

    country = Country.find_by('name = ? OR code = ? OR ? = ANY(aliases)',
                              country_code_or_name, country_code_or_name, country_code_or_name)
    if country.nil?
      country = Country.new
      country_data = JSON.parse(geocode_with_google(country_code_or_name, country_code_or_name, google_auth_key))

      country_results = country_data['results']
      country_results.each do |country_result|
        address_key = country_result['types'].reject { |x| x == 'political' }
                                             .first
        country_result['address_components'].each do |address_component|
          next unless address_component['types'].include?(address_key)

          country.name = address_component['long_name']
          country.code = address_component['short_name']
          country.slug = reslug_em(country.code)
          country.code_longer = ''
        end
        country.latitude = country_result['geometry']['location']['lat']
        country.longitude = country_result['geometry']['location']['lng']
      end

      country.aliases << country_code_or_name
      puts("Country saved: #{country.name}.") if country.save!
    end
    country
  end

  def find_province(province_name, country_code, google_auth_key)
    return if province_name.blank?

    puts "Processing province: #{province_name}."
    province_name = 'Québe' if province_name == 'Quebec'
    country = find_country(country_code, google_auth_key)
    province = Province.find_by('(name = ? OR ? = ANY(aliases)) AND country_id = ?',
                            province_name, province_name, country.id)
    if province.nil?
      province = Province.new
      province.country_id = country.id

      address = "#{province_name}, #{country_code}"
      province_data = JSON.parse(geocode_with_google(address, country_code, google_auth_key))

      province_results = province_data['results']
      province_results.each do |province_result|
        address_key = province_result['types'].reject { |x| x == 'political' }
                                              .first
        province_result['address_components'].each do |address_component|
          next unless address_component['types'].include?(address_key)

          province.name = address_component['long_name']
          province.slug = reslug_em(province.name)
        end
        province.latitude = province_result['geometry']['location']['lat']
        province.longitude = province_result['geometry']['location']['lng']
      end

      province.aliases << province_name
      puts("Province saved: #{province.name}.") if !province.name.nil? && province.save!
    end
    province
  end

  def find_city(city_name, province_name, country_code, google_auth_key)
    puts "Processing city: #{city_name}."

    # Need to do this because Ramallah doesn't have province or country.
    province = find_province(province_name, country_code, google_auth_key)
    if province.nil?
      city = City.find_by('(name = ? OR ? = ANY(aliases))', city_name, city_name)
    else
      city = City.find_by('(name = ? OR ? = ANY(aliases)) AND province_id = ?', city_name, city_name, province.id)
    end

    if city.nil?
      city = City.new

      city.province_id = province.id unless province.nil?

      address = city_name
      address = "#{address}, #{province_name}" unless province_name.blank?

      address = "#{address}, #{country_code}" unless country_code.blank?

      city_data = JSON.parse(geocode_with_google(address, country_code, google_auth_key))

      city_results = city_data['results']
      city_results.each do |city_result|
        address_key = city_result['types'].reject { |x| x == 'political' }
                                          .first
        city_result['address_components'].each do |address_component|
          next unless address_component['types'].include?(address_key)

          city.name = address_component['long_name']
          city.slug = reslug_em(address)
        end
        city.latitude = city_result['geometry']['location']['lat']
        city.longitude = city_result['geometry']['location']['lng']
      end

      city.aliases << city_name
      puts("City saved: #{city.name}.") if !city.name.nil? && city.save
    end
    city
  end

  def geocode_with_google(address, country_code, auth_key)
    puts "Geocoding address: #{address} in province: #{country_code}."
    uri_template = Addressable::Template.new('https://maps.googleapis.com/maps/api/geocode/json{?q*}')
    geocode_uri = uri_template.expand({
      'q' => {
        'key' => auth_key,
        'address' => address,
        'region' => country_code
      }
    })

    uri = URI.parse(geocode_uri)
    Net::HTTP.get(uri)
  end

  def reverse_geocode_with_google(points, auth_key)
    puts "Reverse geocoding location: (#{points[0].x.to_f}, #{points[0].y.to_f})."
    uri_template = Addressable::Template.new('https://maps.googleapis.com/maps/api/geocode/json{?q*}')
    geocode_uri = uri_template.expand({
      'q' => {
        'key' => auth_key,
        'latlng' => "#{points[0].x.to_f}, #{points[0].y.to_f}"
      }
    })

    uri = URI.parse(geocode_uri)
    Net::HTTP.get(uri)
  end

  task :migrate_country_codes, [] => :environment do
    # rubocop:disable Layout/LineLength
    country_iso_mapping = {
      'AF' => 'AFG', 'AX' => 'ALA', 'AL' => 'ALB', 'DZ' => 'DZA', 'AS' => 'ASM', 'AD' => 'AND', 'AO' => 'AGO', 'AI' => 'AIA', 'AQ' => 'ATA', 'AG' => 'ATG', 'AR' => 'ARG', 'AM' => 'ARM', 'AW' => 'ABW', 'AU' => 'AUS', 'AT' => 'AUT', 'AZ' => 'AZE', 'BS' => 'BHS', 'BH' => 'BHR', 'BD' => 'BGD', 'BB' => 'BRB', 'BY' => 'BLR', 'BE' => 'BEL', 'BZ' => 'BLZ', 'BJ' => 'BEN', 'BM' => 'BMU', 'BT' => 'BTN', 'BO' => 'BOL', 'BA' => 'BIH', 'BW' => 'BWA', 'BV' => 'BVT', 'BR' => 'BRA', 'VG' => 'VGB', 'IO' => 'IOT', 'BN' => 'BRN', 'BG' => 'BGR', 'BF' => 'BFA', 'BI' => 'BDI', 'KH' => 'KHM', 'CM' => 'CMR', 'CA' => 'CAN', 'CV' => 'CPV', 'KY' => 'CYM', 'CF' => 'CAF', 'TD' => 'TCD', 'CL' => 'CHL', 'CN' => 'CHN', 'HK' => 'HKG', 'MO' => 'MAC', 'CX' => 'CXR', 'CC' => 'CCK', 'CO' => 'COL', 'KM' => 'COM', 'CG' => 'COG', 'CD' => 'COD', 'CK' => 'COK', 'CR' => 'CRI', 'CI' => 'CIV', 'HR' => 'HRV', 'CU' => 'CUB', 'CY' => 'CYP', 'CZ' => 'CZE', 'DK' => 'DNK', 'DJ' => 'DJI', 'DM' => 'DMA', 'DO' => 'DOM', 'EC' => 'ECU', 'EG' => 'EGY', 'SV' => 'SLV', 'GQ' => 'GNQ', 'ER' => 'ERI', 'EE' => 'EST', 'ET' => 'ETH', 'FK' => 'FLK', 'FO' => 'FRO', 'FJ' => 'FJI', 'FI' => 'FIN', 'FR' => 'FRA', 'GF' => 'GUF', 'PF' => 'PYF', 'TF' => 'ATF', 'GA' => 'GAB', 'GM' => 'GMB', 'GE' => 'GEO', 'DE' => 'DEU', 'GH' => 'GHA', 'GI' => 'GIB', 'GR' => 'GRC', 'GL' => 'GRL', 'GD' => 'GRD', 'GP' => 'GLP', 'GU' => 'GUM', 'GT' => 'GTM', 'GG' => 'GGY', 'GN' => 'GIN', 'GW' => 'GNB', 'GY' => 'GUY', 'HT' => 'HTI', 'HM' => 'HMD', 'VA' => 'VAT', 'HN' => 'HND', 'HU' => 'HUN', 'IS' => 'ISL', 'IN' => 'IND', 'ID' => 'IDN', 'IR' => 'IRN', 'IQ' => 'IRQ', 'IE' => 'IRL', 'IM' => 'IMN', 'IL' => 'ISR', 'IT' => 'ITA', 'JM' => 'JAM', 'JP' => 'JPN', 'JE' => 'JEY', 'JO' => 'JOR', 'KZ' => 'KAZ', 'KE' => 'KEN', 'KI' => 'KIR', 'KP' => 'PRK', 'KR' => 'KOR', 'KW' => 'KWT', 'KG' => 'KGZ', 'LA' => 'LAO', 'LV' => 'LVA', 'LB' => 'LBN', 'LS' => 'LSO', 'LR' => 'LBR', 'LY' => 'LBY', 'LI' => 'LIE', 'LT' => 'LTU', 'LU' => 'LUX', 'MK' => 'MKD', 'MG' => 'MDG', 'MW' => 'MWI', 'MY' => 'MYS', 'MV' => 'MDV', 'ML' => 'MLI', 'MT' => 'MLT', 'MH' => 'MHL', 'MQ' => 'MTQ', 'MR' => 'MRT', 'MU' => 'MUS', 'YT' => 'MYT', 'MX' => 'MEX', 'FM' => 'FSM', 'MD' => 'MDA', 'MC' => 'MCO', 'MN' => 'MNG', 'ME' => 'MNE', 'MS' => 'MSR', 'MA' => 'MAR', 'MZ' => 'MOZ', 'MM' => 'MMR', 'NA' => 'NAM', 'NR' => 'NRU', 'NP' => 'NPL', 'NL' => 'NLD', 'AN' => 'ANT', 'NC' => 'NCL', 'NZ' => 'NZL', 'NI' => 'NIC', 'NE' => 'NER', 'NG' => 'NGA', 'NU' => 'NIU', 'NF' => 'NFK', 'MP' => 'MNP', 'NO' => 'NOR', 'OM' => 'OMN', 'PK' => 'PAK', 'PW' => 'PLW', 'PS' => 'PSE', 'PA' => 'PAN', 'PG' => 'PNG', 'PY' => 'PRY', 'PE' => 'PER', 'PH' => 'PHL', 'PN' => 'PCN', 'PL' => 'POL', 'PT' => 'PRT', 'PR' => 'PRI', 'QA' => 'QAT', 'RE' => 'REU', 'RO' => 'ROU', 'RU' => 'RUS', 'RW' => 'RWA', 'BL' => 'BLM', 'SH' => 'SHN', 'KN' => 'KNA', 'LC' => 'LCA', 'MF' => 'MAF', 'PM' => 'SPM', 'VC' => 'VCT', 'WS' => 'WSM', 'SM' => 'SMR', 'ST' => 'STP', 'SA' => 'SAU', 'SN' => 'SEN', 'RS' => 'SRB', 'SC' => 'SYC', 'SL' => 'SLE', 'SG' => 'SGP', 'SK' => 'SVK', 'SI' => 'SVN', 'SB' => 'SLB', 'SO' => 'SOM', 'ZA' => 'ZAF', 'GS' => 'SGS', 'SS' => 'SSD', 'ES' => 'ESP', 'LK' => 'LKA', 'SD' => 'SDN', 'SR' => 'SUR', 'SJ' => 'SJM', 'SZ' => 'SWZ', 'SE' => 'SWE', 'CH' => 'CHE', 'SY' => 'SYR', 'TW' => 'TWN', 'TJ' => 'TJK', 'TZ' => 'TZA', 'TH' => 'THA', 'TL' => 'TLS', 'TG' => 'TGO', 'TK' => 'TKL', 'TO' => 'TON', 'TT' => 'TTO', 'TN' => 'TUN', 'TR' => 'TUR', 'TM' => 'TKM', 'TC' => 'TCA', 'TV' => 'TUV', 'UG' => 'UGA', 'UA' => 'UKR', 'AE' => 'ARE', 'GB' => 'GBR', 'US' => 'USA', 'UM' => 'UMI', 'UY' => 'URY', 'UZ' => 'UZB', 'VU' => 'VUT', 'VE' => 'VEN', 'VN' => 'VNM', 'VI' => 'VIR', 'WF' => 'WLF', 'EH' => 'ESH', 'YE' => 'YEM', 'ZM' => 'ZMB', 'ZW' => 'ZWE', 'XK' => 'XKX'
    }
    # rubocop:enable Layout/LineLength

    Country.all.each do |country|
      if country.code_longer.nil? || country.code_longer.empty?
        if country_iso_mapping[country.code].nil?
          puts "Couldn't find code for " + country.name
        else
          puts "Adding " + country_iso_mapping[country.code] + " to " + country.name
          country.code_longer = country_iso_mapping[country.code]
          country.save
        end
      end
    end
  end

  task :migrate_locations, [] => :environment do
    auth_token = authenticate_user
    Organization.all.each do |organization|
      puts "Processing #{organization.name} ..."
      organization.locations.each do |location|
        if location.location_type == 'country'
          country = Country.find_by(name: location.name)
          organization.countries.push(country) unless country.nil?
          next
        end

        # Location is a point
        office = Office.new
        office.name = location.name
        office.slug = reslug_em("#{organization.name} #{office.name}")
        office.city = location.city

        province_name = location.state
        org_country = Country.find_by('name = ? OR ? = ANY(aliases)', location.country, location.country)

        if province_name.nil? || province_name.blank?
          response = reverse_geocode(location, auth_token)
          location_data = JSON.parse(response.body)

          office.city = location_data['address']['ShortLabel']
          province_name = location_data['address']['Region']
          country_code = location_data['address']['CountryCode']

          if province_name.nil? || province_name.blank?
            province_element = {}
            province_element['ObjectId'] = 1
            province_element['SingleLine'] = office.city
            province_list = [{ 'attributes': province_element }]

            response = geocode({ 'records': province_list }, country_code, auth_token)
            province_data = JSON.parse(response.body)
            province_data['locations'].each do |province|
              next if province['address'].blank? || province['address'].nil?

              office.city = province['attributes']['City']
              province_name = province['attributes']['Region']
              country_code = province['attributes']['Country']
            end
          end

          org_country = Country.find_by(code_longer: country_code) if org_country.nil?
          puts "Reverse geocoding returned: #{office.city}, #{province_name}, #{org_country.code_longer}!"
        end

        unless org_country.nil?
          puts "Found country for: #{location.country} -> #{org_country.code_longer}."
          office.country_id = org_country.id
        end

        org_province = Province.find_by('name = ? OR ? = ANY(aliases)', province_name, province_name)
        if org_province.nil?
          puts "Geocoding to find: #{province_name} in country #{org_country.code}."
          addresses = build_provinces(province_name, org_country)

          country_code = nil
          country_code = org_country.code_longer unless org_country.nil?

          response = geocode(addresses, country_code, auth_token)
          province_data = JSON.parse(response.body)
          province_data['locations'].each do |province|
            if province['address'].blank? || province['address'].nil?
              puts "Skipping unresolved province: #{province_name}!"
              next
            end

            province_record = Province.new
            province_record.name = province['attributes']['Region']
            province_record.slug = reslug_em(province_record.name)
            province_record.country_id = org_country.id
            province_record.latitude = province['location']['x']
            province_record.longitude = province['location']['y']
            province_record.aliases << province_name

            if province_record.save!
              office.province_id = province_record.id
              puts("Saving province: #{province_record.name}.")
            end
          end
        else
          office.province_id = org_province.id
        end

        office.latitude = location.points[0].x.to_f
        office.longitude = location.points[0].y.to_f

        office.organization = organization

        puts "Office for #{organization.name} -> #{office.name} saved!" if office.save!
      end

      # Done processing the organization. Save it.
      puts "Saving: #{organization.name}!" if organization.save!
    end
  end

  def build_provinces(province_string, country)
    province_list = []
    province_string.split("\n").each_with_index do |province, index|
      if province.blank?
        puts('Skipping blank province!')
        next
      end

      unless country.nil?
        existing_provinces = Province.where('(slug = ? OR ? = ANY(aliases)) AND country_id = ?',
                                        reslug_em(province), province, country.id)
        unless existing_provinces.empty?
          puts("Skipping existing record for #{province} in #{country.code}!")
          next
        end
      end

      puts("Processing: #{province}")

      province_element = {}
      province_element['objectId'] = index + 1
      province_element['province'] = province
      province_list << { 'attributes': province_element }
    end
    { 'records': province_list }
  end

  def authenticate_user
    uri = URI.parse(Rails.configuration.geocode['esri']['auth_uri'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)

    data = { 'client_id' => Rails.configuration.geocode['esri']['client_id'],
             'client_secret' => Rails.configuration.geocode['esri']['client_secret'],
             'grant_type' => Rails.configuration.geocode['esri']['grant_type'] }
    request.set_form_data(data)

    response = http.request(request)
    response_json = JSON.parse(response.body)
    response_json['access_token']
  end

  def reverse_geocode(location, auth_token)
    uri = URI.parse(Rails.configuration.geocode['esri']['reverse_geocode_uri'])
    post_data = {
      'location': "#{location.points[0].y}, #{location.points[0].x}",
      'token': auth_token,
      'f': 'json'
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type': 'multipart/form-data' })
    request.set_form_data(post_data)

    http.request(request)
  end

  def geocode(addresses, country_code, auth_token)
    uri = URI.parse(Rails.configuration.geocode['esri']['convert_uri'])
    post_data = {
      'addresses': addresses.to_json,
      'token': auth_token,
      'f': 'json'
    }

    post_data['sourceCountry'] = country_code unless country_code.nil?

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type': 'multipart/form-data' })
    request.set_form_data(post_data)

    http.request(request)
  end
end
