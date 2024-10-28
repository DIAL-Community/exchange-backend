# frozen_string_literal: true

module Queries
  class CityQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CityType, null: true

    def resolve(slug:)
      city = City.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(city || City.new)
      city
    end
  end

  class CitiesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CityType], null: false

    def resolve(search:)
      validate_access_to_resource(City.new)
      cities = City.order(:name)
      cities = cities.name_contains(search) unless search.blank?
      cities
    end
  end
end
