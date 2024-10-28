# frozen_string_literal: true

require 'modules/site_configuration'

module Mutations
  class CreateTenantSetting < Mutations::BaseMutation
    include Modules::SiteConfiguration

    argument :tenant_name, String, required: true
    argument :tenant_domains, [String], required: true

    argument :allow_unsecured_read, Boolean, required: true

    field :tenant_setting, Types::TenantSettingType, null: true
    field :errors, [String], null: true

    def resolve(tenant_name:, tenant_domains:, allow_unsecured_read:)
      unless an_admin
        return {
          tenant_setting: nil,
          errors: ['Creating / editing tenant setting is not allowed.']
        }
      end

      sanitized_tenant_name = tenant_name.split(/\s+/).join('-').downcase

      existing_tenant = Apartment.tenant_names.include?(sanitized_tenant_name)
      unless existing_tenant
        Apartment::Tenant.create(sanitized_tenant_name)

        Apartment::Tenant.switch(sanitized_tenant_name) do
          # Generate the default site configuration.
          create_default_site_configuration

          %w[
            countries
            provinces
            districts
            origins
            sustainable_development_goals
            sdg_targets
            sectors
            settings
            rubric_categories
            rubric_category_descriptions
          ].each do |table|
            query = <<-TABLE_INSERT_SQL
              INSERT INTO "#{sanitized_tenant_name}".#{table} SELECT * FROM  public.#{table};
            TABLE_INSERT_SQL
            ActiveRecord::Base.connection.exec_query(query)
            query = <<-TABLE_SEQUENCE_SQL
              SELECT                                                                              \
                setval(pg_get_serial_sequence('"#{sanitized_tenant_name}".#{table}', 'id'), MAX(id))
              FROM "#{sanitized_tenant_name}".#{table};
            TABLE_SEQUENCE_SQL
            ActiveRecord::Base.connection.exec_query(query)
          end

          # Category Indicators table has a special type, so do it separately
          query = <<-CATEGORY_INDICATOR_SQL
            INSERT INTO "#{sanitized_tenant_name}".category_indicators
              SELECT
                id,
                name,
                slug,
                indicator_type::text::"#{sanitized_tenant_name}".category_indicator_type,
                weight,
                rubric_category_id,
                data_source,
                source_indicator,
                created_at,
                updated_at,
                script_name
              FROM public.category_indicators;
            CATEGORY_INDICATOR_SQL
          ActiveRecord::Base.connection.exec_query(query)

          query = <<-CATEGORY_INDICATOR_DESCRIPTION_SQL
            INSERT INTO "#{sanitized_tenant_name}".category_indicator_descriptions
            SELECT * FROM  public.category_indicator_descriptions;
          CATEGORY_INDICATOR_DESCRIPTION_SQL
          ActiveRecord::Base.connection.exec_query(query)

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

          exchange_tenant = ExchangeTenant.new(
            allow_unsecured_read:,
            tenant_name: sanitized_tenant_name,
            domain: tenant_domain
          )
          exchange_tenant.save
        end

        ExchangeTenant.where(tenant_name: sanitized_tenant_name)
                      .and(ExchangeTenant.where.not(domain: tenant_domains)).destroy_all
        ExchangeTenant.update_all(allow_unsecured_read:)

        successful_operation = true
      end

      tenant_setting = {
        id: sanitized_tenant_name,
        tenant_name: sanitized_tenant_name,
        tenant_domains:,
        allow_unsecured_read:
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
