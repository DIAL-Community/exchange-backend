# frozen_string_literal: true

namespace :tenants do
  desc 'Create a new tenant'
  task :create_tenant, [:path] => :environment do |_, _|
    Apartment::Tenant.create('fao')

    # Add to Tenants table in database
    ExchangeTenant.create(tenant_name: 'fao', domain: 'fao.localhost')
  end

  task :populate_core_data, [:path] => :environment do |_, _|
    tenant_name = 'fao'

    %w[
      countries
      regions
      districts
      origins
      sustainable_development_goals
      sdg_targets
      sectors
      settings
      rubric_categories
      rubric_category_descriptions
      category_indicator_descriptions
    ].each do |table|
      query = "INSERT INTO #{tenant_name}.#{table} SELECT * FROM  public.#{table};"
      ActiveRecord::Base.connection.exec_query(query)
    end

    # Category Indicators table has a special type, so do it separately
    query = "INSERT INTO #{tenant_name}.category_indicators SELECT id, name, slug, " \
      "indicator_type::text::#{tenant_name}.category_indicator_type, weight, rubric_category_id, " \
      "data_source, source_indicator, created_at, updated_at, script_name FROM public.category_indicators;"
    ActiveRecord::Base.connection.exec_query(query)

    # Create default admin user
    admin_email = "admin@#{tenant_name}.org"
    Apartment::Tenant.switch(tenant_name) do
      admin_user = User.new({ email: admin_email, password: "Admin123", password_confirmation: "Admin123" })
      admin_user.confirm
      admin_user.save
      admin_user.roles = ['admin']
      admin_user.save
    end
  end
end
