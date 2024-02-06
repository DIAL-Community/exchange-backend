# frozen_string_literal: true

module Paginated
  class PaginatedSyncs < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::SyncType], null: false

    def resolve(search:, offset_attributes:)
      return [] unless an_admin

      syncs = TenantSyncConfiguration.order(:name)
      unless search.blank?
        syncs = syncs.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      syncs.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
