# frozen_string_literal: true

module Paginated
  class PaginationAttributeRegion < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return { total_count: 0 }
      end

      regions = Region.order(:name)
      unless search.blank?
        regions = regions.name_contains(search)
      end

      { total_count: regions.count }
    end
  end
end
