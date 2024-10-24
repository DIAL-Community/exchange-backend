# frozen_string_literal: true

module Paginated
  class PaginationAttributeRegion < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(Region.new)

      regions = Region.order(:name)
      unless search.blank?
        regions = regions.name_contains(search)
      end

      { total_count: regions.count }
    end
  end
end
