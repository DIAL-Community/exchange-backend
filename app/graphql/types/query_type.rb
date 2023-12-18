# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :handbooks, resolver: Queries::HandbooksQuery
    field :handbook, resolver: Queries::HandbookQuery
    field :search_handbook, resolver: Queries::SearchHandbookQuery
    field :page_contents, resolver: Queries::PageContentsQuery
    field :export_page_contents, resolver: Queries::ExportPageContentsQuery

    field :products, resolver: Queries::ProductsQuery
    field :product, resolver: Queries::ProductQuery
    field :owned_products, resolver: Queries::OwnedProductsQuery
    field :compare_products, resolver: Queries::CompareProductsQuery

    field :datasets, resolver: Queries::DatasetsQuery
    field :dataset, resolver: Queries::DatasetQuery
    field :owned_datasets, resolver: Queries::OwnedDatasetsQuery

    field :spreadsheet_product, resolver: Queries::SpreadsheetProductQuery
    field :spreadsheet_dataset, resolver: Queries::SpreadsheetDatasetQuery

    field :product_repositories, resolver: Queries::ProductRepositoriesQuery
    field :product_repository, resolver: Queries::ProductRepositoryQuery

    field :endorsers, resolver: Queries::EndorsersQuery

    field :projects, resolver: Queries::ProjectsQuery
    field :project, resolver: Queries::ProjectQuery
    field :search_projects, resolver: Queries::SearchProjectsQuery

    field :building_blocks, resolver: Queries::BuildingBlocksQuery
    field :building_block, resolver: Queries::BuildingBlockQuery

    field :sectors, resolver: Queries::SectorsQuery
    field :sector, resolver: Queries::SectorQuery

    field :origins, resolver: Queries::OriginsQuery

    field :use_cases, resolver: Queries::UseCasesQuery
    field :use_case, resolver: Queries::UseCaseQuery
    field :use_cases_for_sector, resolver: Queries::UseCasesForSectorQuery

    field :use_cases_steps, resolver: Queries::UseCasesStepsQuery
    field :use_case_steps, resolver: Queries::UseCaseStepsQuery
    field :use_case_step, resolver: Queries::UseCaseStepQuery

    field :users, resolver: Queries::UsersQuery
    field :user, resolver: Queries::UserQuery
    field :user_authentication_token_check, resolver: Queries::UserAuthenticationTokenCheckQuery
    field :user_roles, resolver: Queries::UserRolesQuery
    field :user_email_check, resolver: Queries::UserEmailCheckQuery

    field :countries, resolver: Queries::CountriesQuery
    field :country, resolver: Queries::CountryQuery
    field :countries_with_resources, resolver: Queries::CountriesWithResourcesQuery

    field :organizations, resolver: Queries::OrganizationsQuery
    field :organization, resolver: Queries::OrganizationQuery
    field :search_organizations, resolver: Queries::SearchOrganizationsQuery

    field :opportunities, resolver: Queries::OpportunitiesQuery
    field :opportunity, resolver: Queries::OpportunityQuery

    field :aggregators, resolver: Queries::AggregatorsQuery
    field :aggregator, resolver: Queries::AggregatorQuery

    field :capabilities, resolver: Queries::CapabilitiesQuery
    field :operator_services, resolver: Queries::OperatorServicesQuery
    field :capability_only, resolver: Queries::CapabilityOnlyQuery
    field :operator_service_only, resolver: Queries::OperatorServiceOnlyQuery

    field :sdgs, resolver: Queries::SustainableDevelopmentGoalsQuery
    field :sdg, resolver: Queries::SustainableDevelopmentGoalQuery

    field :sdg_targets, resolver: Queries::SustainableDevelopmentGoalTargetsQuery

    field :tags, resolver: Queries::TagsQuery
    field :tag, resolver: Queries::TagQuery

    field :wizard, resolver: Queries::WizardQuery

    field :workflows, resolver: Queries::WorkflowsQuery
    field :workflow, resolver: Queries::WorkflowQuery

    field :candidate_products, resolver: Queries::CandidateProductsQuery
    field :candidate_product, resolver: Queries::CandidateProductQuery

    field :candidate_organizations, resolver: Queries::CandidateOrganizationsQuery
    field :candidate_organization, resolver: Queries::CandidateOrganizationQuery

    field :candidate_roles, resolver: Queries::CandidateRolesQuery
    field :candidate_role, resolver: Queries::CandidateRoleQuery

    field :candidate_datasets, resolver: Queries::CandidateDatasetsQuery
    field :candidate_dataset, resolver: Queries::CandidateDatasetQuery

    field :playbooks, resolver: Queries::PlaybooksQuery
    field :playbook, resolver: Queries::PlaybookQuery
    field :search_playbook_tags, resolver: Queries::SearchPlaybookTagsQuery

    field :plays, resolver: Queries::PlaysQuery
    field :play, resolver: Queries::PlayQuery
    field :search_plays, resolver: Queries::SearchPlaysQuery
    field :search_playbook_plays, resolver: Queries::SearchPlaybookPlaysQuery

    field :moves, resolver: Queries::MovesQuery
    field :move, resolver: Queries::MoveQuery
    field :search_moves, resolver: Queries::SearchMovesQuery

    field :me, resolver: Queries::MeQuery

    field :comments, resolver: Queries::CommentsQuery
    field :count_comments, resolver: Queries::CountCommentsQuery

    field :rubric_categories, resolver: Queries::RubricCategoriesQuery
    field :rubric_category, resolver: Queries::RubricCategoryQuery

    field :category_indicators, resolver: Queries::CategoryIndicatorsQuery
    field :category_indicator, resolver: Queries::CategoryIndicatorQuery

    field :resources, resolver: Queries::ResourcesQuery
    field :resource, resolver: Queries::ResourceQuery

    field :paginated_use_cases, resolver: Paginated::PaginatedUseCases
    field :paginated_wizard_use_cases, resolver: Paginated::PaginatedWizardUseCases
    field :pagination_attribute_use_case, resolver: Paginated::PaginationAttributeUseCase
    field :pagination_wizard_attribute_use_case, resolver: Paginated::PaginationWizardAttributeUseCase

    field :paginated_products, resolver: Paginated::PaginatedProducts
    field :pagination_attribute_product, resolver: Paginated::PaginationAttributeProduct

    field :paginated_building_blocks, resolver: Paginated::PaginatedBuildingBlocks
    field :pagination_attribute_building_block, resolver: Paginated::PaginationAttributeBuildingBlock

    field :paginated_organizations, resolver: Paginated::PaginatedOrganizations
    field :pagination_attribute_organization, resolver: Paginated::PaginationAttributeOrganization
    field :paginated_storefronts, resolver: Paginated::PaginatedStorefronts
    field :pagination_attribute_storefront, resolver: Paginated::PaginationAttributeStorefront

    field :paginated_datasets, resolver: Paginated::PaginatedDatasets
    field :pagination_attribute_dataset, resolver: Paginated::PaginationAttributeDataset

    field :paginated_projects, resolver: Paginated::PaginatedProjects
    field :pagination_attribute_project, resolver: Paginated::PaginationAttributeProject

    field :paginated_candidate_organizations, resolver: Paginated::PaginatedCandidateOrganizations
    field :pagination_attribute_candidate_organization, resolver: Paginated::PaginationAttributeCandidateOrganization

    field :paginated_candidate_products, resolver: Paginated::PaginatedCandidateProducts
    field :pagination_attribute_candidate_product, resolver: Paginated::PaginationAttributeCandidateProduct

    field :paginated_candidate_roles, resolver: Paginated::PaginatedCandidateRoles
    field :pagination_attribute_candidate_role, resolver: Paginated::PaginationAttributeCandidateRole

    field :paginated_candidate_datasets, resolver: Paginated::PaginatedCandidateDatasets
    field :pagination_attribute_candidate_dataset, resolver: Paginated::PaginationAttributeCandidateDataset

    field :paginated_countries, resolver: Paginated::PaginatedCountries
    field :pagination_attribute_country, resolver: Paginated::PaginationAttributeCountry

    field :paginated_sectors, resolver: Paginated::PaginatedSectors
    field :pagination_attribute_sector, resolver: Paginated::PaginationAttributeSector

    field :paginated_tags, resolver: Paginated::PaginatedTags
    field :pagination_attribute_tag, resolver: Paginated::PaginationAttributeTag

    field :paginated_workflows, resolver: Paginated::PaginatedWorkflows
    field :pagination_attribute_workflow, resolver: Paginated::PaginationAttributeWorkflow

    field :paginated_cities, resolver: Paginated::PaginatedCities
    field :pagination_attribute_city, resolver: Paginated::PaginationAttributeCity
    field :cities, resolver: Queries::CitiesQuery
    field :city, resolver: Queries::CityQuery

    field :paginated_contacts, resolver: Paginated::PaginatedContacts
    field :pagination_attribute_contact, resolver: Paginated::PaginationAttributeContact
    field :contacts, resolver: Queries::ContactsQuery
    field :contact, resolver: Queries::ContactQuery

    field :paginated_opportunities, resolver: Paginated::PaginatedOpportunities
    field :pagination_attribute_opportunity, resolver: Paginated::PaginationAttributeOpportunity

    field :paginated_resources, resolver: Paginated::PaginatedResources
    field :pagination_attribute_resource, resolver: Paginated::PaginationAttributeResource

    field :paginated_playbooks, resolver: Paginated::PaginatedPlaybooks
    field :pagination_attribute_playbook, resolver: Paginated::PaginationAttributePlaybook

    field :paginated_users, resolver: Paginated::PaginatedUsers
    field :pagination_attribute_user, resolver: Paginated::PaginationAttributeUser

    field :bookmark, resolver: Queries::BookmarkQuery
    field :owners, resolver: Queries::OwnersQuery

    field :paginated_task_trackers, resolver: Paginated::PaginatedTaskTrackers
    field :pagination_attribute_task_tracker, resolver: Paginated::PaginationAttributeTaskTracker
    field :task_trackers, resolver: Queries::TaskTrackersQuery
    field :task_tracker, resolver: Queries::TaskTrackerQuery

    field :regions, resolver: Queries::RegionsQuery
    field :region, resolver: Queries::RegionQuery
    field :paginated_regions, resolver: Paginated::PaginatedRegions
    field :pagination_attribute_region, resolver: Paginated::PaginationAttributeRegion

    field :starred_objects, resolver: Queries::StarredObjectsQuery
    field :starred_object, resolver: Queries::StarredObjectQuery
  end
end
