# frozen_string_literal: true

module Queries
  class TenantSettingQuery < Queries::BaseQuery
    argument :tenant_name, String, required: false, default_value: nil
    type Types::TenantSettingType, null: true

    def resolve(tenant_name:)
      validate_access_to_resource(SiteSetting.new)

      tenant_domains = {}
      tenant_unsecure_read = {}
      ExchangeTenant.where(tenant_name:).each do |exchange_tenant|
        current_tenant_domains = tenant_domains[exchange_tenant.tenant_name]
        if current_tenant_domains.nil?
          tenant_domains[exchange_tenant.tenant_name] = []
        end
        tenant_domains[exchange_tenant.tenant_name] << exchange_tenant.domain
        tenant_unsecure_read[exchange_tenant.tenant_name] = exchange_tenant.allow_unsecured_read
      end

      # Return nil if we don't have any data with tenant_name.
      return nil if tenant_domains.empty?

      {
        id: tenant_name,
        tenant_name:,
        tenant_domains: tenant_domains[tenant_name],
        allow_unsecured_read: tenant_unsecure_read[tenant_name]
      }
    end
  end

  class TenantSettingsQuery < Queries::BaseQuery
    type [Types::TenantSettingType], null: true

    def resolve
      validate_access_to_resource(SiteSetting.new)

      tenant_domains = {}
      tenant_unsecure_read = {}
      ExchangeTenant.all.each do |exchange_tenant|
        current_tenant_domains = tenant_domains[exchange_tenant.tenant_name]
        if current_tenant_domains.nil?
          tenant_domains[exchange_tenant.tenant_name] = []
        end
        tenant_domains[exchange_tenant.tenant_name] << exchange_tenant.domain
        tenant_unsecure_read[exchange_tenant.tenant_name] = exchange_tenant.allow_unsecured_read
      end

      tenant_settings = []
      ExchangeTenant
        .distinct
        .order(:tenant_name)
        .pluck(:tenant_name)
        .each do |tenant_name|
        tenant_settings << {
          id: tenant_name,
          tenant_name:,
          tenant_domains: tenant_domains[tenant_name],
          allow_unsecured_read: tenant_unsecure_read[tenant_name]
        }
      end
      tenant_settings
    end
  end
end
