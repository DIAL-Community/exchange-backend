# frozen_string_literal: true

module Paginated
  class PaginationAttributeCountry < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      countries = Country.order(:name)
      unless search.blank?
        countries = countries.name_contains(search)
      end

      { total_count: countries.count }
    end
  end
end