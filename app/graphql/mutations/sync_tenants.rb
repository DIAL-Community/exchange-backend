# frozen_string_literal: true

module Mutations
  class SyncTenants < Mutations::BaseMutation
    argument :source_tenant, String, required: true
    argument :destination_tenant, String, required: true

    argument :building_block_slugs, [String], required: true
    argument :dataset_slugs, [String], required: true
    argument :product_slugs, [String], required: true
    argument :project_slugs, [String], required: true
    argument :use_case_slugs, [String], required: true

    field :sync_completed, String, null: true
    field :errors, [String], null: true

    def resolve(
      source_tenant:, destination_tenant:,
      building_block_slugs:, dataset_slugs:, product_slugs:, project_slugs:, use_case_slugs:
    )
      puts "Source tenant: '#{source_tenant}'."
      puts "Destination tenant: '#{destination_tenant}'."
      Apartment::Tenant.switch!

      successful_operation = false
      ActiveRecord::Base.transaction do
        building_block_slugs.each do |slug|
          Apartment::Tenant.switch!(source_tenant)
          existing_building_block = BuildingBlock.find_by(slug:)
          next if existing_building_block.nil?

          puts "Syncing building block '#{slug}'..."
          duplicate_building_block = existing_building_block.amoeba_dup
          Apartment::Tenant.switch!(destination_tenant)
          duplicate_building_block.save!
        end

        dataset_slugs.each do |slug|
          Apartment::Tenant.switch!(source_tenant)
          existing_dataset = Dataset.find_by(slug:)
          next if existing_dataset.nil?

          puts "Syncing dataset '#{slug}'..."
          duplicate_dataset = existing_dataset.amoeba_dup
          Apartment::Tenant.switch!(destination_tenant)
          duplicate_dataset.save!
        end

        product_slugs.each do |slug|
          Apartment::Tenant.switch!(source_tenant)
          existing_product = Product.find_by(slug:)
          next if existing_product.nil?

          puts "Syncing product '#{slug}'..."
          duplicate_product = existing_product.amoeba_dup
          Apartment::Tenant.switch!(destination_tenant)
          duplicate_product.save!
        end

        project_slugs.each do |slug|
          Apartment::Tenant.switch!(source_tenant)
          existing_project = Project.find_by(slug:)
          next if existing_project.nil?

          puts "Syncing project '#{slug}'..."
          duplicate_project = existing_project.amoeba_dup
          Apartment::Tenant.switch!(destination_tenant)
          duplicate_project.save!
        end

        use_case_slugs.each do |slug|
          Apartment::Tenant.switch!(source_tenant)
          existing_use_case = UseCase.find_by(slug:)
          next if existing_use_case.nil?

          puts "Syncing use case '#{slug}'..."
          duplicate_use_case = existing_use_case.amoeba_dup
          Apartment::Tenant.switch!(destination_tenant)
          duplicate_use_case.save!
        end

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          sync_completed: 'Sync process successful.',
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          sync_completed: nil,
          errors: ['Sync process failed.']
        }
      end
    end
  end
end