# frozen_string_literal: true

module Paginated
  class PaginationAttributeCity < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(City.new)

      cities = City.order(:name)
      unless search.blank?
        cities = cities.name_contains(search)
      end

      { total_count: cities.count }
    end
  end
end
