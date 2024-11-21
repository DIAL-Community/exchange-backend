# frozen_string_literal: true

module Mutations
  class DeleteTenantSetting < Mutations::BaseMutation
    argument :tenant_name, String, required: true

    field :tenant_setting, Types::TenantSettingType, null: true
    field :errors, [String], null: true

    def resolve(tenant_name:)
      exchange_tenants = ExchangeTenant.where(tenant_name:)
      exchange_tenant_policy = Pundit.policy(context[:current_user], ExchangeTenant.new)
      if exchange_tenants.empty? || !exchange_tenant_policy.delete_allowed?
        return {
          tenant_setting: nil,
          errors: ['Deleting tenant setting is not allowed.']
        }
      end

      Apartment::Tenant.drop(tenant_name)

      successful_operation = false
      ActiveRecord::Base.transaction do
        exchange_tenants.destroy_all
        successful_operation = true
      end

      tenant_setting = {
        id: tenant_name,
        tenant_name:,
        tenant_domains: [],
        allow_unsecured_read: false
      }

      if successful_operation
        # Successful deletion, return the deleted tenant_setting with no errors
        {
          tenant_setting:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          tenant_setting: nil,
          errors: tenant_setting.errors.full_messages
        }
      end
    end
  end
end
