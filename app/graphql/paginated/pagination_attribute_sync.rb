# frozen_string_literal: true

module Paginated
  class PaginationAttributeSync < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      return { total_count: 0 } unless an_admin

      syncs = TenantSync.order(:name)
      unless search.blank?
        syncs = syncs.name_contains(search)
      end

      { total_count: syncs.count }
    end
  end
end
