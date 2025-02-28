# frozen_string_literal: true

module Queries
  class SyncQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SyncType, null: true

    def resolve(slug:)
      sync_configuration = TenantSyncConfiguration.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(SiteSetting.new)
      sync_configuration
    end
  end

  class SyncsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::SyncType], null: false

    def resolve(search:)
      validate_access_to_resource(SiteSetting.new)
      syncs = TenantSyncConfiguration.order(:name)
      syncs = syncs.name_contains(search) unless search.blank?
      syncs
    end
  end
end
