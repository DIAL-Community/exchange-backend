require 'modules/maturity_sync'
require 'modules/slugger'
require 'modules/track'
require 'kramdown'
require 'nokogiri'

include Modules::MaturitySync
include Modules::Slugger
include Modules::Track
include Kramdown
include Nokogiri

namespace :health_sync do
  task :sync_healthtech_indicators, [:path] => :environment do |_, _params|
    ENV['tenant'].nil? ? tenant_name = 'health' : tenant_name = ENV['tenant']
    
    Apartment::Tenant.switch(tenant_name) do
      health_maturity = YAML.load_file('config/maturity_health.yml')
      health_maturity.each do |health_category|
        rubric_category = create_category(health_category['category'], health_category['description'])

        category_count = health_category['indicators'].count
        health_category['indicators'].each do |indicator|
          puts "Category: #{health_category['name']} INDICATOR: #{indicator['name']}"
          create_indicator(indicator['name'], indicator['description'], 'Africa CDC', category_count,
            indicator['type'], rubric_category.id)
        end
      end
    end
  end

  task :sync_health_categories, [:path] => :environment do |_, _params|
    ENV['tenant'].nil? ? tenant_name = 'health' : tenant_name = ENV['tenant']
    
    Apartment::Tenant.switch(tenant_name) do
      health_categories = YAML.load_file('config/software_categories.yml')
      health_categories.each do |health_category|
        new_category = SoftwareCategory.where(name: health_category['category']).first || SoftwareCategory.new
        new_category.name = health_category['category']
        new_category.slug = reslug_em(health_category['category'])
        new_category.description = health_category['description']
        new_category.save!

        health_category['features'].each do |feature|
          new_feature = SoftwareFeature.where(name: feature['name'], software_category_id: new_category.id).first || SoftwareFeature.new
          new_feature.name = feature['name']
          new_feature.slug = reslug_em(feature['name'])
          new_feature.description = feature['description']
          new_feature.software_category_id = new_category.id
          new_feature.facility_scale = feature['health_facility_scale']
          new_feature.save!
        end
      end
    end
  end
end
