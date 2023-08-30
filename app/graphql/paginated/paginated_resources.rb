# frozen_string_literal: true

module Paginated
  class PaginatedResources < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :show_in_exchange, Boolean, required: false, default_value: false
    argument :show_in_wizard, Boolean, required: false, default_value: false
    argument :offset_attributes, Attributes::OffsetAttributes, required: true

    type [Types::ResourceType], null: false

    def resolve(search:, show_in_exchange:, show_in_wizard:, offset_attributes:)
      resources = Resource.order(:name)
      unless search.blank?
        resources = resources.name_contains(search)
      end

      resources = resources.where(show_in_exchange: true) if show_in_exchange
      resources = resources.where(show_in_wizard: true) if show_in_wizard

      offset_params = offset_attributes.to_h
      resources.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
