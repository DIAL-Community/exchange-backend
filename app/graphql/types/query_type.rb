# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :counts, resolver: Queries::CountsQuery

    field :handbooks, resolver: Queries::HandbooksQuery
    field :handbook, resolver: Queries::HandbookQuery
    field :search_handbook, resolver: Queries::SearchHandbookQuery
    field :page_contents, resolver: Queries::PageContentsQuery
    field :export_page_contents, resolver: Queries::ExportPageContentsQuery

    field :products, resolver: Queries::ProductsQuery
    field :product, resolver: Queries::ProductQuery
    field :search_products, resolver: Queries::SearchProductsQuery
    field :paginated_products, resolver: Queries::PaginatedProductsQuery
    field :owned_products, resolver: Queries::OwnedProductsQuery

    field :datasets, resolver: Queries::DatasetsQuery
    field :dataset, resolver: Queries::DatasetQuery
    field :search_datasets, resolver: Queries::SearchDatasetsQuery
    field :paginated_datasets, resolver: Queries::PaginatedDatasetsQuery

    field :spreadsheet_product, resolver: Queries::SpreadsheetProductQuery
    field :spreadsheet_dataset, resolver: Queries::SpreadsheetDatasetQuery

    field :product_repositories, resolver: Queries::ProductRepositoriesQuery
    field :product_repository, resolver: Queries::ProductRepositoryQuery

    field :endorsers, resolver: Queries::EndorsersQuery

    field :projects, resolver: Queries::ProjectsQuery
    field :project, resolver: Queries::ProjectQuery
    field :search_projects, resolver: Queries::SearchProjectsQuery
    field :paginated_projects, resolver: Queries::PaginatedProjectsQuery

    field :building_blocks, resolver: Queries::BuildingBlocksQuery
    field :building_block, resolver: Queries::BuildingBlockQuery
    field :search_building_blocks, resolver: Queries::SearchBuildingBlocksQuery

    field :sectors, resolver: Queries::SectorsQuery
    field :sector, resolver: Queries::SectorQuery
    field :search_sectors, resolver: Queries::SearchSectorsQuery
    field :sectors_with_subs, resolver: Queries::SectorsWithSubsQuery

    field :origins, resolver: Queries::OriginsQuery
    field :search_origins, resolver: Queries::SearchOriginsQuery

    field :use_cases, resolver: Queries::UseCasesQuery
    field :use_case, resolver: Queries::UseCaseQuery
    field :search_use_cases, resolver: Queries::SearchUseCasesQuery
    field :use_cases_for_sector, resolver: Queries::UseCasesForSectorQuery

    field :use_cases_steps, resolver: Queries::UseCasesStepsQuery
    field :use_case_steps, resolver: Queries::UseCaseStepsQuery
    field :use_case_step, resolver: Queries::UseCaseStepQuery

    field :users, resolver: Queries::UsersQuery
    field :user, resolver: Queries::UserQuery
    field :search_users, resolver: Queries::SearchUsersQuery
    field :user_authentication_token_check, resolver: Queries::UserAuthenticationTokenCheckQuery
    field :user_roles, resolver: Queries::UserRolesQuery
    field :user_email_check, resolver: Queries::UserEmailCheckQuery

    field :countries, resolver: Queries::CountriesQuery
    field :country, resolver: Queries::CountryQuery
    field :search_countries, resolver: Queries::SearchCountriesQuery

    field :organizations, resolver: Queries::OrganizationsQuery
    field :organization, resolver: Queries::OrganizationQuery
    field :search_organizations, resolver: Queries::SearchOrganizationsQuery
    field :search_storefronts, resolver: Queries::SearchStorefrontsQuery

    field :opportunities, resolver: Queries::OpportunitiesQuery
    field :opportunity, resolver: Queries::OpportunityQuery
    field :search_opportunities, resolver: Queries::SearchOpportunitiesQuery

    field :aggregators, resolver: Queries::AggregatorsQuery
    field :aggregator, resolver: Queries::AggregatorQuery
    field :search_aggregators, resolver: Queries::SearchAggregatorsQuery
    field :paginated_aggregators, resolver: Queries::PaginatedAggregatorsQuery

    field :capabilities, resolver: Queries::CapabilitiesQuery
    field :operator_services, resolver: Queries::OperatorServicesQuery
    field :capability_only, resolver: Queries::CapabilityOnlyQuery
    field :operator_service_only, resolver: Queries::OperatorServiceOnlyQuery

    field :sdgs, resolver: Queries::SustainableDevelopmentGoalsQuery
    field :sdg, resolver: Queries::SustainableDevelopmentGoalQuery
    field :search_sdgs, resolver: Queries::SearchSustainableDevelopmentGoalsQuery

    field :sdg_targets, resolver: Queries::SustainableDevelopmentGoalTargetsQuery

    field :tags, resolver: Queries::TagsQuery
    field :tag, resolver: Queries::TagQuery
    field :search_tags, resolver: Queries::SearchTagsQuery

    field :wizard, resolver: Queries::WizardQuery

    field :workflows, resolver: Queries::WorkflowsQuery
    field :workflow, resolver: Queries::WorkflowQuery
    field :search_workflows, resolver: Queries::SearchWorkflowsQuery

    field :candidate_products, resolver: Queries::CandidateProductsQuery
    field :candidate_product, resolver: Queries::CandidateProductQuery
    field :search_candidate_products, resolver: Queries::SearchCandidateProductsQuery

    field :candidate_organizations, resolver: Queries::CandidateOrganizationsQuery
    field :candidate_organization, resolver: Queries::CandidateOrganizationQuery
    field :search_candidate_organizations, resolver: Queries::SearchCandidateOrganizationsQuery

    field :candidate_roles, resolver: Queries::CandidateRolesQuery
    field :candidate_role, resolver: Queries::CandidateRoleQuery
    field :search_candidate_roles, resolver: Queries::SearchCandidateRolesQuery

    field :candidate_datasets, resolver: Queries::CandidateDatasetsQuery
    field :candidate_dataset, resolver: Queries::CandidateDatasetQuery
    field :search_candidate_datasets, resolver: Queries::SearchCandidateDatasetsQuery
    field :owned_datasets, resolver: Queries::OwnedDatasetsQuery

    field :playbooks, resolver: Queries::PlaybooksQuery
    field :playbook, resolver: Queries::PlaybookQuery
    field :search_playbooks, resolver: Queries::SearchPlaybooksQuery
    field :search_playbook_tags, resolver: Queries::SearchPlaybookTagsQuery
    field :paginated_playbooks, resolver: Queries::PaginatedPlaybooksQuery

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
    field :search_resources, resolver: Queries::SearchResourcesQuery

    field :paginated_use_cases, resolver: Paginated::PaginatedUseCases
    field :pagination_attribute_use_case, resolver: Paginated::PaginationAttributeUseCase

    field :paginated_products_redux, resolver: Paginated::PaginatedProducts
    field :pagination_attribute_product, resolver: Paginated::PaginationAttributeProduct

    field :paginated_building_blocks, resolver: Paginated::PaginatedBuildingBlocks
    field :pagination_attribute_building_block, resolver: Paginated::PaginationAttributeBuildingBlock

    field :paginated_organizations, resolver: Paginated::PaginatedOrganizations
    field :pagination_attribute_organization, resolver: Paginated::PaginationAttributeOrganization

    field :paginated_datasets_redux, resolver: Paginated::PaginatedDatasets
    field :pagination_attribute_dataset, resolver: Paginated::PaginationAttributeDataset

    field :paginated_projects_redux, resolver: Paginated::PaginatedProjects
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

    field :paginated_playbooks_redux, resolver: Paginated::PaginatedPlaybooks
    field :pagination_attribute_playbook, resolver: Paginated::PaginationAttributePlaybook

    field :bookmark, resolver: Queries::BookmarkQuery
    field :owners, resolver: Queries::OwnersQuery
  end
end
