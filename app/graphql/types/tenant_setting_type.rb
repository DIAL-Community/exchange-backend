# frozen_string_literal: true

module Types
  class TenantSettingType < BaseObject
    field :id, ID, null: false
    field :tenant_name, String, null: false
    field :tenant_domains, [String], null: false

    field :allow_unsecured_read, Boolean, null: false

    field :initialized, Boolean, null: false
    def initialized
      Apartment.tenant_names.include?(object[:tenant_name])
    end
  end
end
