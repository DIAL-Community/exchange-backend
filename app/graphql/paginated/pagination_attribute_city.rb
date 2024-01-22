# frozen_string_literal: true

module Paginated
  class PaginationAttributeCity < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      cities = City.order(:name)
      unless search.blank?
        cities = cities.name_contains(search)
      end

      { total_count: cities.count }
    end
  end
end
