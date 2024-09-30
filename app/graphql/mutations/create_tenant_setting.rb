# frozen_string_literal: true

module Mutations
  class CreateTenantSetting < Mutations::BaseMutation
    argument :tenant_name, String, required: true
    argument :tenant_domains, [String], required: true

    argument :allow_unsecure_read, Boolean, required: true

    field :tenant_setting, Types::TenantSettingType, null: true
    field :errors, [String], null: true

    def resolve(tenant_name:, tenant_domains:, allow_unsecure_read:)
      unless an_admin
        return {
          tenant_setting: nil,
          errors: ['Must have proper rights to update a tenant setting object.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        tenant_domains.each do |tenant_domain|
          next if tenant_domain.blank?

          exchange_tenant = ExchangeTenant.find_by(tenant_name:, domain: tenant_domain)
          next unless exchange_tenant.nil?

          exchange_tenant = ExchangeTenant.new(tenant_name:, domain: tenant_domain)
          exchange_tenant.save
        end

        ExchangeTenant.update_all(allow_unsecure_read:)
        successful_operation = true
      end

      tenant_setting = {
        tenant_name:,
        tenant_domains: domains,
        allow_unsecure_read:
      }

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          tenant_setting:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          tenant_setting: nil,
          errors: resource.errors.full_messages
        }
      end
    end
  end
end
