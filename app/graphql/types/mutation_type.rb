# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_candidate_product, mutation: Mutations::CreateCandidateProduct
    field :create_candidate_organization, mutation: Mutations::CreateCandidateOrganization

    field :create_playbook, mutation: Mutations::CreatePlaybook
    field :auto_save_playbook, mutation: Mutations::CreatePlaybook
    field :delete_playbook, mutation: Mutations::DeletePlaybook

    field :create_play, mutation: Mutations::CreatePlay
    field :auto_save_play, mutation: Mutations::CreatePlay
    field :update_play_order, mutation: Mutations::UpdatePlayOrder
    field :duplicate_play, mutation: Mutations::DuplicatePlay

    field :create_move, mutation: Mutations::CreateMove
    field :auto_save_move, mutation: Mutations::CreateMove
    field :update_move_order, mutation: Mutations::UpdateMoveOrder
    field :create_resource, mutation: Mutations::CreateResource

    field :update_user, mutation: Mutations::UpdateUser

    field :create_spreadsheet_data, mutation: Mutations::CreateSpreadsheetData
    field :delete_spreadsheet_data, mutation: Mutations::DeleteSpreadsheetData

    field :create_product_repository, mutation: Mutations::CreateProductRepository
    field :update_product_repository, mutation: Mutations::UpdateProductRepository
    field :delete_product_repository, mutation: Mutations::DeleteProductRepository

    field :create_organization, mutation: Mutations::CreateOrganization
    field :delete_organization, mutation: Mutations::DeleteOrganization

    field :update_organization_country, mutation: Mutations::UpdateOrganizationCountry
    field :update_organization_contacts, mutation: Mutations::UpdateOrganizationContacts
    field :update_organization_products, mutation: Mutations::UpdateOrganizationProducts
    field :update_organization_sectors, mutation: Mutations::UpdateOrganizationSectors
    field :update_organization_projects, mutation: Mutations::UpdateOrganizationProjects
    field :update_organization_offices, mutation: Mutations::UpdateOrganizationOffices

    field :create_product, mutation: Mutations::CreateProduct

    field :update_product_sectors, mutation: Mutations::UpdateProductSectors
    field :update_product_building_blocks, mutation: Mutations::UpdateProductBuildingBlocks
    field :update_product_organizations, mutation: Mutations::UpdateProductOrganizations
    field :update_product_projects, mutation: Mutations::UpdateProductProjects
    field :update_product_tags, mutation: Mutations::UpdateProductTags
    field :update_product_sdgs, mutation: Mutations::UpdateProductSdgs

    field :create_dataset, mutation: Mutations::CreateDataset
    field :update_dataset_countries, mutation: Mutations::UpdateDatasetCountries
    field :update_dataset_organizations, mutation: Mutations::UpdateDatasetOrganizations
    field :update_dataset_sdgs, mutation: Mutations::UpdateDatasetSdgs
    field :update_dataset_sectors, mutation: Mutations::UpdateDatasetSectors
    field :update_dataset_tags, mutation: Mutations::UpdateDatasetTags

    field :create_project, mutation: Mutations::CreateProject

    field :update_project_organizations, mutation: Mutations::UpdateProjectOrganizations
    field :update_project_products, mutation: Mutations::UpdateProjectProducts
    field :update_project_sectors, mutation: Mutations::UpdateProjectSectors
    field :update_project_countries, mutation: Mutations::UpdateProjectCountries
    field :update_project_tags, mutation: Mutations::UpdateProjectTags

    field :create_use_case, mutation: Mutations::CreateUseCase

    field :update_use_case_sdg_targets, mutation: Mutations::UpdateUseCaseSdgTargets
    field :update_use_case_tags, mutation: Mutations::UpdateUseCaseTags

    field :create_use_case_step, mutation: Mutations::CreateUseCaseStep

    field :update_use_case_step_workflows, mutation: Mutations::UpdateUseCaseStepWorkflows
    field :update_use_case_step_products, mutation: Mutations::UpdateUseCaseStepProducts
    field :update_use_case_step_building_blocks, mutation: Mutations::UpdateUseCaseStepBuildingBlocks

    field :create_building_block, mutation: Mutations::CreateBuildingBlock

    field :update_building_block_workflows, mutation: Mutations::UpdateBuildingBlockWorkflows
    field :update_building_block_products, mutation: Mutations::UpdateBuildingBlockProducts

    field :create_sector, mutation: Mutations::CreateSector
    field :delete_sector, mutation: Mutations::DeleteSector

    field :create_workflow, mutation: Mutations::CreateWorkflow
    field :update_workflow_building_blocks, mutation: Mutations::UpdateWorkflowBuildingBlocks

    field :create_country, mutation: Mutations::CreateCountry
    field :delete_country, mutation: Mutations::DeleteCountry

    field :create_tag, mutation: Mutations::CreateTag
    field :delete_tag, mutation: Mutations::DeleteTag

    field :create_comment, mutation: Mutations::CreateComment
    field :delete_comment, mutation: Mutations::DeleteComment

    field :create_rubric_category, mutation: Mutations::CreateRubricCategory
    field :delete_rubric_category, mutation: Mutations::DeleteRubricCategory

    field :delete_category_indicator, mutation: Mutations::DeleteCategoryIndicator
    field :create_category_indicator, mutation: Mutations::CreateCategoryIndicator
  end
end
