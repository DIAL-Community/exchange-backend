# frozen_string_literal: true

module Types
  class TenantSettingType < BaseObject
    field :id, ID, null: false
    field :tenant_name, String, null: false
    field :tenant_domains, [String], null: false

    field :allow_unsecure_read, Boolean, null: false
  end
end
