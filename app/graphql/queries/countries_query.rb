# frozen_string_literal: true

module Queries
  class CountriesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CountryType], null: false

    def resolve(search:)
      countries = Country.order(:name)
      countries = countries.name_contains(search) unless search.blank?
      countries
    end
  end

  class CountryQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CountryType, null: true

    def resolve(slug:)
      Country.find_by(slug:)
    end
  end

  class CountriesWithResourcesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CountryType], null: false

    def resolve(search:)
      countries = Country.joins(:resources).order(:name)
      countries = countries.name_contains(search) unless search.blank?
      countries.distinct
    end
  end
end
