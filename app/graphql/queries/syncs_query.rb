# frozen_string_literal: true

module Queries
  class SyncsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::SyncType], null: false

    def resolve(search:)
      return [] unless an_admin

      syncs = TenantSyncConfiguration.order(:name)
      syncs = syncs.name_contains(search) unless search.blank?
      syncs
    end
  end

  class SyncQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SyncType, null: true

    def resolve(slug:)
      return nil unless an_admin

      TenantSyncConfiguration.find_by(slug:)
    end
  end
end
