# frozen_string_literal: true

module Paginated
  class PaginationAttributeResource < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :show_in_exchange, Boolean, required: false, default_value: false
    argument :show_in_wizard, Boolean, required: false, default_value: false

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, show_in_exchange:, show_in_wizard:)
      resources = Resource.order(:name)
      unless search.blank?
        resources = resources.name_contains(search)
      end

      resources = resources.where(show_in_exchange: true) if show_in_exchange
      resources = resources.where(show_in_wizard: true) if show_in_wizard

      { total_count: resources.count }
    end
  end
end
