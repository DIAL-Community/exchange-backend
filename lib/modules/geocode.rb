# frozen_string_literal: true

module Modules
  module Geocode
    def find_country(country_code_or_name, _google_auth_key)
      return if country_code_or_name.blank?

      puts "Processing country data: #{country_code_or_name}."
      Country.find_by(
        'name = :param OR code = :param OR code_longer = :param OR :param = ANY(aliases)',
        param: country_code_or_name
      )
    end

    def find_province(province_name, country_code, google_auth_key)
      return if province_name.blank?

      puts "Processing province data: #{province_name}."
      country = find_country(country_code, google_auth_key)
      province = Province.find_by(
        '(name = :province_param OR :province_param = ANY(aliases)) AND country_id = :country_param',
        province_param: province_name,
        country_param: country.id
      ) unless country.nil?

      puts "Province pre-geocoding: #{province.inspect}."
      if province.nil?
        province = Province.new
        province.country_id = country.id unless country.nil?

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
      puts "Province: #{province.inspect}."
      province
    end

    def find_city(city_name, province_name, country_code, google_auth_key)
      puts "Processing city data: #{city_name}."

      # Need to do this because Ramallah doesn't have province or country.
      province = find_province(province_name, country_code, google_auth_key)
      if province.nil?
        city = City.find_by(
          '(name = :city_param OR :city_param = ANY(aliases))',
          city_param: city_name,
        )
      else
        city = City.find_by(
          '(name = :city_param OR :city_param = ANY(aliases)) AND province_id = :province_param',
          city_param: city_name,
          province_param: province.id
        )
      end

      puts "City pre-geocoding: #{city.inspect}."
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
        puts("City saved: #{city.name}.") if !city.name.nil? && city.save!
      end
      puts "Returned city data: #{city.inspect}."
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
  end
end
