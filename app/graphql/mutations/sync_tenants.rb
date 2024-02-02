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

    def sync_opportunities(source_tenant, destination_tenant, opportunity_slugs)
      Apartment::Tenant.switch!
      opportunity_slugs.each do |slug|
        Apartment::Tenant.switch!(source_tenant)
        source_opportunity = Opportunity.find_by(slug:)
        next if source_opportunity.nil?

        amoeba_opportunity = source_opportunity.amoeba_dup

        puts "Syncing opportunity '#{slug}'..."
        Apartment::Tenant.switch!(destination_tenant)
        destination_opportunity = Opportunity.find_by(slug:)
        if destination_opportunity.nil?
          destination_opportunity = amoeba_opportunity
          destination_opportunity.save!
        else
          destination_opportunity.sync_record(amoeba_opportunity)
        end
      end
      Apartment::Tenant.switch!
    end

    def sync_workflows(source_tenant, destination_tenant, workflow_slugs)
      Apartment::Tenant.switch!
      workflow_slugs.each do |slug|
        Apartment::Tenant.switch!(source_tenant)
        source_workflow = Workflow.find_by(slug:)
        next if source_workflow.nil?

        amoeba_workflow = source_workflow.amoeba_dup

        puts "Syncing workflow '#{slug}'..."
        Apartment::Tenant.switch!(destination_tenant)
        destination_workflow = Workflow.find_by(slug:)
        if destination_workflow.nil?
          destination_workflow = amoeba_workflow
          destination_workflow.save!
        else
          destination_workflow.sync_record(amoeba_workflow)
        end
      end
      Apartment::Tenant.switch!
    end

    def sync_building_blocks(source_tenant, destination_tenant, building_block_slugs)
      Apartment::Tenant.switch!
      building_block_slugs.each do |slug|
        Apartment::Tenant.switch!(source_tenant)
        source_building_block = BuildingBlock.find_by(slug:)
        next if source_building_block.nil?

        amoeba_building_block = source_building_block.amoeba_dup

        # Prepare the associations as they may not available on the destination schema
        opportunity_slugs = source_building_block.opportunities.map(&:slug)
        sync_opportunities(source_tenant, destination_tenant, opportunity_slugs)
        product_slugs = source_building_block.products.map(&:slug)
        sync_products(source_tenant, destination_tenant, product_slugs)
        workflow_slugs = source_building_block.workflows.map(&:slug)
        sync_workflows(source_tenant, destination_tenant, workflow_slugs)

        puts "Syncing building block '#{slug}'..."
        Apartment::Tenant.switch!(destination_tenant)
        destination_building_block = BuildingBlock.find_by(slug:)
        if destination_building_block.nil?
          destination_building_block = amoeba_building_block
          # Not using amoeba-ed building block here because we excluded the associations
          destination_building_block.sync_associations(source_building_block)
          destination_building_block.save!
        else
          # Not using amoeba-ed building block here because we excluded the associations
          destination_building_block.sync_associations(source_building_block)
          destination_building_block.sync_record(amoeba_building_block)
        end
      end
      Apartment::Tenant.switch!
    end

    def sync_organizations(source_tenant, destination_tenant, organization_slugs)
      Apartment::Tenant.switch!
      organization_slugs.each do |slug|
        Apartment::Tenant.switch!(source_tenant)
        source_organization = Organization.find_by(slug:)
        next if source_organization.nil?

        amoeba_organization = source_organization.amoeba_dup

        puts "Syncing organization '#{slug}'..."
        Apartment::Tenant.switch!(destination_tenant)
        destination_organization = Organization.find_by(slug:)
        if destination_organization.nil?
          destination_organization = amoeba_organization
          destination_organization.save!
        else
          destination_organization.sync_record(amoeba_organization)
        end
      end
      Apartment::Tenant.switch!
    end

    def sync_datasets(source_tenant, destination_tenant, dataset_slugs)
      Apartment::Tenant.switch!
      dataset_slugs.each do |slug|
        Apartment::Tenant.switch!(source_tenant)
        source_dataset = Dataset.find_by(slug:)
        next if source_dataset.nil?

        amoeba_dataset = source_dataset.amoeba_dup

        # Prepare the associations as they may not available on the destination schema
        organization_slugs = source_dataset.organizations.map(&:slug)
        sync_organizations(source_tenant, destination_tenant, organization_slugs)

        puts "Syncing dataset '#{slug}'..."
        Apartment::Tenant.switch!(destination_tenant)
        destination_dataset = Dataset.find_by(slug:)
        if destination_dataset.nil?
          destination_dataset = amoeba_dataset
          # Not using amoeba-ed building block here because we excluded the associations
          destination_dataset.sync_associations(source_dataset)
          destination_dataset.save!
        else
          # Not using amoeba-ed building block here because we excluded the associations
          destination_dataset.sync_associations(source_dataset)
          destination_dataset.sync_record(amoeba_dataset)
        end
      end
      Apartment::Tenant.switch!
    end

    def sync_products(source_tenant, destination_tenant, product_slugs)
      Apartment::Tenant.switch!
      product_slugs.each do |slug|
        Apartment::Tenant.switch!(source_tenant)
        source_product = Product.find_by(slug:)
        next if source_product.nil?

        amoeba_product = source_product.amoeba_dup

        # Prepare the associations as they may not available on the destination schema
        organization_slugs = source_product.organizations.map(&:slug)
        sync_organizations(source_tenant, destination_tenant, organization_slugs)

        puts "Syncing building block '#{slug}'..."
        Apartment::Tenant.switch!(destination_tenant)
        destination_product = Product.find_by(slug:)
        if destination_product.nil?
          destination_product = amoeba_product
          destination_product.sync_associations(source_product)
          destination_product.save!
        else
          destination_product.sync_associations(source_product)
          destination_product.sync_record(amoeba_product)
        end
      end
      Apartment::Tenant.switch!
    end

    def sync_projects(source_tenant, destination_tenant, project_slugs)
      Apartment::Tenant.switch!
      project_slugs.each do |slug|
        Apartment::Tenant.switch!(source_tenant)
        source_project = Project.find_by(slug:)
        next if source_project.nil?

        amoeba_project = source_project.amoeba_dup

        puts "Syncing building block '#{slug}'..."
        Apartment::Tenant.switch!(destination_tenant)
        destination_project = Project.find_by(slug:)
        if destination_project.nil?
          destination_project = amoeba_project
          destination_project.save!
        else
          destination_project.sync_record(amoeba_project)
        end
      end
      Apartment::Tenant.switch!
    end

    def sync_use_cases(source_tenant, destination_tenant, use_case_slugs)
      Apartment::Tenant.switch!
      use_case_slugs.each do |slug|
        Apartment::Tenant.switch!(source_tenant)
        source_use_case = UseCase.find_by(slug:)
        next if source_use_case.nil?

        amoeba_use_case = source_use_case.amoeba_dup

        puts "Syncing building block '#{slug}'..."
        Apartment::Tenant.switch!(destination_tenant)
        destination_use_case = UseCase.find_by(slug:)
        if destination_use_case.nil?
          destination_use_case = amoeba_use_case
          destination_use_case.save!
        else
          destination_use_case.sync_record(amoeba_use_case)
        end
      end
      Apartment::Tenant.switch!
    end

    def resolve(
      source_tenant:, destination_tenant:,
      building_block_slugs:, dataset_slugs:, product_slugs:, project_slugs:, use_case_slugs:
    )
      puts "Source tenant: '#{source_tenant}'."
      puts "Destination tenant: '#{destination_tenant}'."
      Apartment::Tenant.switch!

      successful_operation = false
      ActiveRecord::Base.transaction do
        sync_building_blocks(source_tenant, destination_tenant, building_block_slugs)
        sync_datasets(source_tenant, destination_tenant, dataset_slugs)
        sync_products(source_tenant, destination_tenant, product_slugs)
        sync_projects(source_tenant, destination_tenant, project_slugs)
        sync_use_cases(source_tenant, destination_tenant, use_case_slugs)
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
