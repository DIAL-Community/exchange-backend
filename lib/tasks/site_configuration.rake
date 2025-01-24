# frozen_string_literal: true

require 'modules/slugger'
require 'modules/site_configuration'

include Modules::Slugger
include Modules::SiteConfiguration

namespace :site_configuration do
  desc 'Regenerate default site configurations.'
  task regenerate_default_site_configuration: :environment do
    create_default_site_configuration
    Apartment.tenant_names.each do |tenant_name|
      Apartment::Tenant.switch(tenant_name) do
        create_default_site_configuration
      end
    end
  end

  desc 'Regenerate default site configurations for a single tenant.'
  task regenerate_site_config_for_tenant: :environment do
    unless ENV['tenant'].nil?
      tenant_name = ENV['tenant']
      Apartment::Tenant.switch(tenant_name) do
        create_default_site_configuration
      end
    end
  end

  desc 'Regenerate default candidate approval workflow configurations.'
  task regenerate_default_candidate_approval_workflow: :environment do
    create_default_candidate_approval_workflow
    Apartment.tenant_names.each do |tenant_name|
      Apartment::Tenant.switch(tenant_name) do
        create_default_candidate_approval_workflow
      end
    end
  end
end
