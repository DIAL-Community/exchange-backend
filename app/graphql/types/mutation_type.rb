# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_candidate_product, mutation: Mutations::CreateCandidateProduct
    field :create_candidate_organization, mutation: Mutations::CreateCandidateOrganization
    field :create_candidate_dataset, mutation: Mutations::CreateCandidateDataset
    field :approve_reject_candidate_dataset, mutation: Mutations::ApproveRejectCandidateDataset

    field :create_playbook, mutation: Mutations::CreatePlaybook
    field :auto_save_playbook, mutation: Mutations::CreatePlaybook
    field :delete_playbook, mutation: Mutations::DeletePlaybook
    field :delete_playbook_play, mutation: Mutations::DeletePlaybookPlay
    field :update_playbook_plays, mutation: Mutations::UpdatePlaybookPlays

    field :create_play, mutation: Mutations::CreatePlay
    field :auto_save_play, mutation: Mutations::CreatePlay
    field :duplicate_play, mutation: Mutations::DuplicatePlay
    field :delete_play_move, mutation: Mutations::DeletePlayMove
    field :update_play_moves, mutation: Mutations::UpdatePlayMoves

    field :create_move, mutation: Mutations::CreateMove
    field :auto_save_move, mutation: Mutations::CreateMove
    field :create_move_resource, mutation: Mutations::CreateMoveResource

    field :create_user, mutation: Mutations::CreateUser
    field :delete_user, mutation: Mutations::DeleteUser

    field :create_spreadsheet_data, mutation: Mutations::CreateSpreadsheetData
    field :delete_spreadsheet_data, mutation: Mutations::DeleteSpreadsheetData

    field :create_product_repository, mutation: Mutations::CreateProductRepository
    field :delete_product_repository, mutation: Mutations::DeleteProductRepository

    field :create_opportunity, mutation: Mutations::CreateOpportunity
    field :delete_opportunity, mutation: Mutations::DeleteOpportunity

    field :update_opportunity_building_blocks, mutation: Mutations::UpdateOpportunityBuildingBlocks
    field :update_opportunity_countries, mutation: Mutations::UpdateOpportunityCountries
    field :update_opportunity_organizations, mutation: Mutations::UpdateOpportunityOrganizations
    field :update_opportunity_sectors, mutation: Mutations::UpdateOpportunitySectors
    field :update_opportunity_use_cases, mutation: Mutations::UpdateOpportunityUseCases
    field :update_opportunity_tags, mutation: Mutations::UpdateOpportunityTags

    field :create_organization, mutation: Mutations::CreateOrganization
    field :delete_organization, mutation: Mutations::DeleteOrganization

    field :update_organization_countries, mutation: Mutations::UpdateOrganizationCountries
    field :update_organization_contacts, mutation: Mutations::UpdateOrganizationContacts
    field :update_organization_products, mutation: Mutations::UpdateOrganizationProducts
    field :update_organization_sectors, mutation: Mutations::UpdateOrganizationSectors
    field :update_organization_projects, mutation: Mutations::UpdateOrganizationProjects
    field :update_organization_offices, mutation: Mutations::UpdateOrganizationOffices
    field :update_organization_resources, mutation: Mutations::UpdateOrganizationResources
    field :update_organization_specialties, mutation: Mutations::UpdateOrganizationSpecialties
    field :update_organization_certifications, mutation: Mutations::UpdateOrganizationCertifications
    field :update_organization_building_blocks, mutation: Mutations::UpdateOrganizationBuildingBlocks

    field :create_product, mutation: Mutations::CreateProduct
    field :delete_product, mutation: Mutations::DeleteProduct

    field :update_product_sectors, mutation: Mutations::UpdateProductSectors
    field :update_product_building_blocks, mutation: Mutations::UpdateProductBuildingBlocks
    field :update_product_organizations, mutation: Mutations::UpdateProductOrganizations
    field :update_product_projects, mutation: Mutations::UpdateProductProjects
    field :update_product_countries, mutation: Mutations::UpdateProductCountries
    field :update_product_tags, mutation: Mutations::UpdateProductTags
    field :update_product_sdgs, mutation: Mutations::UpdateProductSdgs
    field :update_product_resources, mutation: Mutations::UpdateProductResources
    field :update_product_indicators, mutation: Mutations::UpdateProductIndicators

    field :create_dataset, mutation: Mutations::CreateDataset
    field :delete_dataset, mutation: Mutations::DeleteDataset

    field :update_dataset_countries, mutation: Mutations::UpdateDatasetCountries
    field :update_dataset_organizations, mutation: Mutations::UpdateDatasetOrganizations
    field :update_dataset_sdgs, mutation: Mutations::UpdateDatasetSdgs
    field :update_dataset_sectors, mutation: Mutations::UpdateDatasetSectors
    field :update_dataset_tags, mutation: Mutations::UpdateDatasetTags

    field :create_project, mutation: Mutations::CreateProject
    field :delete_project, mutation: Mutations::DeleteProject

    field :update_project_organizations, mutation: Mutations::UpdateProjectOrganizations
    field :update_project_products, mutation: Mutations::UpdateProjectProducts
    field :update_project_sectors, mutation: Mutations::UpdateProjectSectors
    field :update_project_countries, mutation: Mutations::UpdateProjectCountries
    field :update_project_sdgs, mutation: Mutations::UpdateProjectSdgs
    field :update_project_tags, mutation: Mutations::UpdateProjectTags

    field :create_use_case, mutation: Mutations::CreateUseCase
    field :delete_use_case, mutation: Mutations::DeleteUseCase

    field :update_use_case_sdg_targets, mutation: Mutations::UpdateUseCaseSdgTargets
    field :update_use_case_tags, mutation: Mutations::UpdateUseCaseTags

    field :create_use_case_step, mutation: Mutations::CreateUseCaseStep

    field :update_use_case_step_workflows, mutation: Mutations::UpdateUseCaseStepWorkflows
    field :update_use_case_step_datasets, mutation: Mutations::UpdateUseCaseStepDatasets
    field :update_use_case_step_products, mutation: Mutations::UpdateUseCaseStepProducts
    field :update_use_case_step_building_blocks, mutation: Mutations::UpdateUseCaseStepBuildingBlocks

    field :create_building_block, mutation: Mutations::CreateBuildingBlock
    field :delete_building_block, mutation: Mutations::DeleteBuildingBlock

    field :update_building_block_workflows, mutation: Mutations::UpdateBuildingBlockWorkflows
    field :update_building_block_products, mutation: Mutations::UpdateBuildingBlockProducts

    field :create_sector, mutation: Mutations::CreateSector
    field :delete_sector, mutation: Mutations::DeleteSector

    field :create_workflow, mutation: Mutations::CreateWorkflow
    field :delete_workflow, mutation: Mutations::DeleteWorkflow
    field :update_workflow_building_blocks, mutation: Mutations::UpdateWorkflowBuildingBlocks

    field :create_country, mutation: Mutations::CreateCountry
    field :delete_country, mutation: Mutations::DeleteCountry

    field :create_contact, mutation: Mutations::CreateContact
    field :delete_contact, mutation: Mutations::DeleteContact

    field :create_city, mutation: Mutations::CreateCity
    field :delete_city, mutation: Mutations::DeleteCity

    field :create_tag, mutation: Mutations::CreateTag
    field :delete_tag, mutation: Mutations::DeleteTag

    field :create_resource_topic, mutation: Mutations::CreateResourceTopic
    field :delete_resource_topic, mutation: Mutations::DeleteResourceTopic

    field :create_comment, mutation: Mutations::CreateComment
    field :delete_comment, mutation: Mutations::DeleteComment

    field :create_rubric_category, mutation: Mutations::CreateRubricCategory
    field :update_rubric_category_indicators, mutation: Mutations::UpdateRubricCategoryIndicators
    field :delete_rubric_category, mutation: Mutations::DeleteRubricCategory

    field :delete_category_indicator, mutation: Mutations::DeleteCategoryIndicator
    field :create_category_indicator, mutation: Mutations::CreateCategoryIndicator

    field :create_wizard_guidance_mail, mutation: Mutations::CreateWizardGuidanceMail

    field :apply_as_owner, mutation: Mutations::ApplyAsOwner
    field :apply_as_content_editor, mutation: Mutations::ApplyAsContentEditor

    field :approve_reject_candidate_role, mutation: Mutations::ApproveRejectCandidateRole

    field :create_resource, mutation: Mutations::CreateResource
    field :delete_resource, mutation: Mutations::DeleteResource

    field :add_bookmark, mutation: Mutations::AddBookmark
    field :remove_bookmark, mutation: Mutations::RemoveBookmark

    field :create_starred_object, mutation: Mutations::CreateStarredObject
    field :remove_starred_object, mutation: Mutations::RemoveStarredObject

    field :create_task_tracker, mutation: Mutations::CreateTaskTracker

    field :update_resource_tags, mutation: Mutations::UpdateResourceTags
    field :update_resource_countries, mutation: Mutations::UpdateResourceCountries
    field :update_resource_products, mutation: Mutations::UpdateResourceProducts
    field :update_resource_resource_topics, mutation: Mutations::UpdateResourceResourceTopics

    field :create_region, mutation: Mutations::CreateRegion
    field :delete_region, mutation: Mutations::DeleteRegion
    field :update_region_countries, mutation: Mutations::UpdateRegionCountries

    field :create_sync, mutation: Mutations::CreateSync
    field :delete_sync, mutation: Mutations::DeleteSync
    field :sync_tenants, mutation: Mutations::SyncTenants

    field :create_chatbot_conversation, mutation: Mutations::CreateChatbotConversation

    field :create_adli_user, mutation: Mutations::CreateAdliUser

    field :create_message, mutation: Mutations::CreateMessage
    field :delete_message, mutation: Mutations::DeleteMessage
    field :update_message_visibility, mutation: Mutations::UpdateMessageVisibility
  end
end
