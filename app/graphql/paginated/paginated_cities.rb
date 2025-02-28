# frozen_string_literal: true

module Paginated
  class PaginatedCities < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CityType], null: false

    def resolve(search:, offset_attributes:)
      # Validate access to the current entity type.
      validate_access_to_resource(City.new)

      cities = City.order(:name)
      unless search.blank?
        cities = cities.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      cities.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
