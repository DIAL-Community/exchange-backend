# frozen_string_literal: true
require 'modules/maturity_sync'
require 'modules/slugger'
require 'modules/track'
require 'kramdown'
require 'nokogiri'
require 'roo'

include Modules::MaturitySync
include Modules::Slugger
include Modules::Track
include Kramdown
include Nokogiri

namespace :health_sync do
  task :sync_healthtech_indicators, [:path] => :environment do |_, _params|
    ENV['tenant'].nil? ? tenant_name = 'health' : tenant_name = ENV['tenant']

    Apartment::Tenant.switch(tenant_name) do
      # if user set the purge flag, then delete all the existing categories and indicators
      if ENV['purge'] == 'true'
        puts 'purging existing categories'
        ProductIndicator.delete_all
        CategoryIndicatorDescription.delete_all
        CategoryIndicator.delete_all
        RubricCategoryDescription.delete_all
        RubricCategory.delete_all
      end
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
      # if user set the purge flag, then delete all the existing categories
      if ENV['purge'] == 'true'
        puts 'purging existing categories'
        SoftwareFeature.delete_all
        SoftwareCategory.delete_all
      end
      health_categories = YAML.load_file('config/software_categories.yml')
      health_categories.each do |health_category|
        new_category = SoftwareCategory.where(name: health_category['category']).first || SoftwareCategory.new
        new_category.name = health_category['category']
        new_category.slug = reslug_em(health_category['category'])
        new_category.description = health_category['description']
        new_category.save!

        health_category['features'].each do |feature|
          puts "processing feature: #{feature['name']}"
          new_feature = SoftwareFeature.where(name: feature['name'],
software_category_id: new_category.id).first || SoftwareFeature.new
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

  task :sync_google_forms, [:path] => :environment do |_, _params|
    ENV['tenant'].nil? ? tenant_name = 'health' : tenant_name = ENV['tenant']

    Apartment::Tenant.switch(tenant_name) do
      vetting_sheet = Roo::Spreadsheet.open('utils/HealthVettedSolutions.xlsx')
      solution_sheet = Roo::Spreadsheet.open('utils/HealthSolutionsData.xlsx')

      vetting_sheet.each do |vetted_data|
        # Find the solution in the solution data
        solution_sheet.each do |solution_data|
          next unless solution_data[4] == vetted_data[1]
          puts "Found solution: #{solution_data[4]}"
          product_name = solution_data[4]
          health_product = Product.first_duplicate(product_name, reslug_em(product_name))
          health_product = Product.new if health_product.nil?

          health_product.name = product_name
          health_product.slug = reslug_em(product_name)
          health_product.save!

          product_description = ProductDescription.find_by(locale: 'en', product_id: health_product.id)
          product_description = ProductDescription.new if product_description.nil?
          product_description.product_id = health_product.id
          product_description.locale = 'en'
          product_description.description = solution_data[5]
          product_description.save!

          solution_categories = solution_data[9].split(',')
          category_column_mapping = [
            { name: 'Electronic Health Record', column: 45 },
            { name: 'Pharmacy', column: 46 },
            { name: 'Laboratory and Diagnostics', column: 47 },
            { name: 'Disease Surveillance', column: 48 },
            { name: 'National and Community Health', column: 49 },
            { name: 'Analytics and Data Aggregation', column: 50 },
            { name: 'AI for Health', column: 51 },
            { name: 'Virtual Health', column: 52 },
            { name: 'Front-line (CHW) tools', column: 53 },
            { name: 'Vaccination', column: 54 }
          ]
          solution_categories.each do |solution_category|
            category = SoftwareCategory.find_by(name: solution_category.strip)
            next if category.nil?
            health_product.software_categories << category unless health_product.software_categories.include?(category)

            read_column = category_column_mapping.find { |c| c[:name] == solution_category.strip }
            solution_features = solution_data[read_column[:column]]
            next if solution_features.nil?
            solution_features.split(',').each do |solution_feature|
              feature = SoftwareFeature.find_by(slug: reslug_em(solution_feature.strip))
              # Should we create feature if not found?
              next if feature.nil?
              health_product.software_features << feature unless health_product.software_features.include?(feature)
            end

            health_product.save!
          end

          health_product.website = cleanup_url(solution_data[6]) unless solution_data[6].blank?

          # populate countries
          countries = solution_data[14].split(',')
          countries.each do |country|
            product_country = Country.find_by(name: country.strip)
            next if product_country.nil?
            health_product.countries << product_country unless health_product.countries.include?(product_country)
          end

          # populate attributes for local impact and product stage
          extra_attributes = []
          extra_attributes << { 'name': 'Relevance', 'value': solution_data[11] } unless solution_data[11].blank?
          extra_attributes << { 'name': 'Impact', 'value': solution_data[10] } unless solution_data[10].blank?

          extra_attributes <<  { 'name': 'Deployments', 'type': 'product_stage',
                                 'value': vetted_data[8] } unless vetted_data[8].blank?
          extra_attributes <<  { 'name': 'Deployed Countries', 'type': 'product_stage',
                                 'value': vetted_data[9] } unless vetted_data[9].blank?
          extra_attributes <<  { 'name': 'Active Users', 'type': 'product_stage',
                                 'value': vetted_data[10] } unless vetted_data[10].blank?
          extra_attributes <<  { 'name': 'Transactions per month', 'type': 'product_stage',
                                 'value': vetted_data[11] } unless vetted_data[11].blank?
          extra_attributes <<  { 'name': 'Annual Revenue', 'type': 'product_stage',
                                 'value': vetted_data[12] } unless vetted_data[12].blank?
          extra_attributes <<  { 'name': 'Funding Raised', 'type': 'product_stage',
                                 'value': vetted_data[13] } unless vetted_data[13].blank?
          health_product.extra_attributes = extra_attributes

          # populate maturity rubric
          health_indicators = [
            { name: 'data-importexport-using-fhir', column: 14 },
            { name: 'integration-with-national-health-systems', column: 16 },
            { name: 'has-open-api-for-integration', column: 15 },
            { name: 'has-a-privacy-policy', column: 17 },
            { name: 'pii-and-phi-are-encrypted-at-storage-and-in-api-calls', column: 18 },
            { name: 'offers-scalable-deployment-mechanisms', column: 19 },
            { name: 'active-developers', column: 22 },
            { name: 'releases', column: 23 },
            { name: 'audit-logging-and-error-reporting', column: 20 },
            { name: 'secure-authorization-mechanisms', column: 21 },
            { name: 'offlinelow-bandwidth-functionality', column: 24 },
            { name: 'customizable-fields-and-forms', column: 26 },
            { name: 'internationalization', column: 25 },
            { name: 'accessibility', column: 27 }
          ]

          health_indicators.each do |health_indicator|
            category_indicator = CategoryIndicator.find_by(slug: health_indicator[:name])
            product_indicator = ProductIndicator.find_by(category_indicator_id: category_indicator.id,
                                                        product_id: health_product.id)
            if product_indicator.nil?
              product_indicator = ProductIndicator.new(category_indicator_id: category_indicator.id,
                                                      product_id: health_product.id)
            end

            indicator_data = vetted_data[health_indicator[:column]]
            if indicator_data.nil? || indicator_data.blank? || indicator_data == 'Unknown'
              product_indicator.destroy!
            else
              if indicator_data == 'yes' || indicator_data == 'Yes'
                indicator_data = true
              end
              if indicator_data == 'no' || indicator_data == 'No'
                indicator_data = false
              end
              if indicator_data.is_a?(String)
                if indicator_data.include?("high")
                  indicator_data = 'high'
                end
                if indicator_data.include?("medium")
                  indicator_data = 'medium'
                end
                if indicator_data.include?("low")
                  indicator_data = 'low'
                end
              end
              product_indicator.indicator_value = indicator_data
              product_indicator.save!
            end
          end

          health_product.save
          calculate_maturity_scores(health_product.id)

          next if solution_data[7].blank?
          upload_user = User.find_by(username: 'admin')
          begin
            uploader = LogoUploader.new(health_product, solution_data[7], upload_user)
            uploader.download!(solution_data[7])
            uploader.store!
          rescue StandardError => e
            puts "Unable to save image for: #{health_product.name}. Standard error: #{e}."
          end
        end
      end
    end
  end
end
