# frozen_string_literal: true

module Paginated
  class PaginatedCountries < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::CountryType], null: false

    def resolve(search:, offset_attributes:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return []
      end

      countries = Country.order(:name)
      unless search.blank?
        countries = countries.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      countries.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
