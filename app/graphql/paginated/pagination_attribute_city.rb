# frozen_string_literal: true

module Paginated
  class PaginationAttributeCity < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      cities = City.order(:name)
      unless search.blank?
        cities = cities.name_contains(search)
      end

      { total_count: cities.count }
    end
  end
end
