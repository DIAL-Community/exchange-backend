# frozen_string_literal: true

namespace :tenants do
  desc 'Create a new tenant'
  task :create_tenant, [:path] => :environment do |_, _|
    Apartment::Tenant.create('fao')

    # Add to Tenants table in database
    ExchangeTenant.create(tenant_name: 'fao', domain: 'fao.localhost')
  end
end
