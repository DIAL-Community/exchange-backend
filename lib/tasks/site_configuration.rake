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
end
