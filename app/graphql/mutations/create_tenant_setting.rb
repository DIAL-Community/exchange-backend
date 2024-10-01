# frozen_string_literal: true

require 'modules/site_configuration'

module Mutations
  class CreateTenantSetting < Mutations::BaseMutation
    include Modules::SiteConfiguration

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

      sanitized_tenant_name = tenant_name.split(/\s+/).join('-').downcase

      existing_tenant = Apartment.tenant_names.include?(sanitized_tenant_name)
      unless existing_tenant
        Apartment::Tenant.create(sanitized_tenant_name)

        Apartment::Tenant.switch(sanitized_tenant_name) do
          # Generate the default site configuration.
          create_default_site_configuration

          admin_email = "admin@#{sanitized_tenant_name}.org"
          admin_user = User.new({
            email: admin_email,
            username: 'admin',
            password: "admin-#{sanitized_tenant_name}",
            password_confirmation: "admin-#{sanitized_tenant_name}"
          })
          admin_user.confirm
          if admin_user.save
            puts "Admin user created for tenant #{sanitized_tenant_name} with email: #{admin_email}."
          end

          admin_user.roles << 'admin'
          if admin_user.save
            puts "Admin user role added for tenant #{sanitized_tenant_name}."
          end
        end
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        tenant_domains.each do |tenant_domain|
          next if tenant_domain.blank?

          exchange_tenant = ExchangeTenant.find_by(tenant_name: sanitized_tenant_name, domain: tenant_domain)
          next unless exchange_tenant.nil?

          exchange_tenant = ExchangeTenant.new(tenant_name: sanitized_tenant_name, domain: tenant_domain)
          exchange_tenant.save
        end

        ExchangeTenant.where(tenant_name: sanitized_tenant_name)
                      .and(ExchangeTenant.where.not(domain: tenant_domains)).destroy_all
        ExchangeTenant.update_all(allow_unsecure_read:)

        successful_operation = true
      end

      tenant_setting = {
        id: sanitized_tenant_name,
        tenant_name: sanitized_tenant_name,
        tenant_domains:,
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
