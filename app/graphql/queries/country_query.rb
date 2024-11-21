# frozen_string_literal: true

module Queries
  class CountryQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CountryType, null: true

    def resolve(slug:)
      country = Country.find_by(slug:) if valid_slug?(slug)
      validate_access_to_instance(country || Country.new)
      country
    end
  end

  class CountriesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CountryType], null: false

    def resolve(search:)
      validate_access_to_resource(Country.new)
      countries = Country.order(:name)
      countries = countries.name_contains(search) unless search.blank?
      countries
    end
  end

  class CountriesWithResourcesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CountryType], null: false

    def resolve(search:)
      validate_access_to_resource(Country.new)
      countries = Country.joins(:resources).order(:name)
      countries = countries.name_contains(search) unless search.blank?
      countries.distinct
    end
  end
end
