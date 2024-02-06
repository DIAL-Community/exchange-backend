# frozen_string_literal: true

module Types
  class SyncType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :description, String, null: false

    field :tenant_source, String, null: false
    field :tenant_destination, String, null: false
    field :sync_enabled, Boolean, null: false

    field :sync_configuration, GraphQL::Types::JSON, null: false

    field :last_sync_at, GraphQL::Types::ISO8601Date, null: true
  end
end
