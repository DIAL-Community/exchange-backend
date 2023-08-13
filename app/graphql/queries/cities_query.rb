# frozen_string_literal: true

module Queries
  class CitiesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CityType], null: false

    def resolve(search:)
      return [] unless an_admin

      cities = City.order(:name)
      cities = cities.name_contains(search) unless search.blank?
      cities
    end
  end

  class CityQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CityType, null: true

    def resolve(slug:)
      return nil unless an_admin

      City.find_by(slug:)
    end
  end
end
