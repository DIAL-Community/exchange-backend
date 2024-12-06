# frozen_string_literal: true

module Registry
  class QueryType < Types::BaseObject
    field :handbook, resolver: Queries::HandbookQuery
    field :handbooks, resolver: Queries::HandbooksQuery
    field :page_contents, resolver: Queries::PageContentsQuery
    field :search_handbook, resolver: Queries::SearchHandbookQuery
    field :export_page_contents, resolver: Queries::ExportPageContentsQuery

    field :product, resolver: Queries::ProductQuery
    field :products, resolver: Queries::ProductsQuery
    field :owned_products, resolver: Queries::OwnedProductsQuery
    field :search_products, resolver: Queries::SearchProductsQuery
    field :compare_products, resolver: Queries::CompareProductsQuery

    field :dataset, resolver: Queries::DatasetQuery
    field :datasets, resolver: Queries::DatasetsQuery
    field :owned_datasets, resolver: Queries::OwnedDatasetsQuery

    field :spreadsheet_product, resolver: Queries::SpreadsheetProductQuery
    field :spreadsheet_dataset, resolver: Queries::SpreadsheetDatasetQuery

    field :product_repositories, resolver: Queries::ProductRepositoriesQuery
    field :product_repository, resolver: Queries::ProductRepositoryQuery

    field :endorsers, resolver: Queries::EndorsersQuery

    field :project, resolver: Queries::ProjectQuery
    field :projects, resolver: Queries::ProjectsQuery
    field :search_projects, resolver: Queries::SearchProjectsQuery

    field :building_block, resolver: Queries::BuildingBlockQuery
    field :building_blocks, resolver: Queries::BuildingBlocksQuery

    field :sector, resolver: Queries::SectorQuery
    field :sectors, resolver: Queries::SectorsQuery

    field :origin, resolver: Queries::OriginQuery
    field :origins, resolver: Queries::OriginsQuery

    field :use_case, resolver: Queries::UseCaseQuery
    field :use_cases, resolver: Queries::UseCasesQuery
    field :use_cases_for_sector, resolver: Queries::UseCasesForSectorQuery

    field :use_case_step, resolver: Queries::UseCaseStepQuery
    field :use_case_steps, resolver: Queries::UseCaseStepsQuery
    field :use_cases_steps, resolver: Queries::UseCasesStepsQuery

    field :user, resolver: Queries::UserQuery
    field :users, resolver: Queries::UsersQuery
    field :user_authentication_token_check, resolver: Queries::UserAuthenticationTokenCheckQuery

    field :user_roles, resolver: Queries::UserRolesQuery
    field :user_email_check, resolver: Queries::UserEmailCheckQuery

    field :country, resolver: Queries::CountryQuery
    field :countries, resolver: Queries::CountriesQuery
    field :countries_with_resources, resolver: Queries::CountriesWithResourcesQuery

    field :organization, resolver: Queries::OrganizationQuery
    field :organizations, resolver: Queries::OrganizationsQuery
    field :search_organizations, resolver: Queries::SearchOrganizationsQuery

    field :opportunity, resolver: Queries::OpportunityQuery
    field :opportunities, resolver: Queries::OpportunitiesQuery

    field :aggregator, resolver: Queries::AggregatorQuery
    field :aggregators, resolver: Queries::AggregatorsQuery

    field :capabilities, resolver: Queries::CapabilitiesQuery
    field :operator_services, resolver: Queries::OperatorServicesQuery

    field :capability_only, resolver: Queries::CapabilityOnlyQuery
    field :operator_service_only, resolver: Queries::OperatorServiceOnlyQuery

    field :sdg, resolver: Queries::SustainableDevelopmentGoalQuery
    field :sdgs, resolver: Queries::SustainableDevelopmentGoalsQuery

    field :sdg_target, resolver: Queries::SustainableDevelopmentGoalTargetQuery
    field :sdg_targets, resolver: Queries::SustainableDevelopmentGoalTargetsQuery

    field :tag, resolver: Queries::TagQuery
    field :tags, resolver: Queries::TagsQuery

    field :wizard, resolver: Queries::WizardQuery

    field :workflow, resolver: Queries::WorkflowQuery
    field :workflows, resolver: Queries::WorkflowsQuery

    field :candidate_product, resolver: Queries::CandidateProductQuery
    field :candidate_products, resolver: Queries::CandidateProductsQuery
    field :candidate_product_extra_attributes, resolver: Queries::CandidateProductExtraAttributesQuery

    field :candidate_organization, resolver: Queries::CandidateOrganizationQuery
    field :candidate_organizations, resolver: Queries::CandidateOrganizationsQuery

    field :candidate_role, resolver: Queries::CandidateRoleQuery
    field :candidate_roles, resolver: Queries::CandidateRolesQuery

    field :candidate_dataset, resolver: Queries::CandidateDatasetQuery
    field :candidate_datasets, resolver: Queries::CandidateDatasetsQuery

    field :candidate_resource, resolver: Queries::CandidateResourceQuery
    field :candidate_resources, resolver: Queries::CandidateResourcesQuery

    field :playbook, resolver: Queries::PlaybookQuery
    field :playbooks, resolver: Queries::PlaybooksQuery
    field :search_playbook_tags, resolver: Queries::SearchPlaybookTagsQuery

    field :play, resolver: Queries::PlayQuery
    field :plays, resolver: Queries::PlaysQuery
    field :search_plays, resolver: Queries::SearchPlaysQuery
    field :search_playbook_plays, resolver: Queries::SearchPlaybookPlaysQuery

    field :move, resolver: Queries::MoveQuery
    field :moves, resolver: Queries::MovesQuery
    field :search_moves, resolver: Queries::SearchMovesQuery

    field :me, resolver: Queries::MeQuery

    field :comments, resolver: Queries::CommentsQuery
    field :count_comments, resolver: Queries::CountCommentsQuery

    field :rubric_category, resolver: Queries::RubricCategoryQuery
    field :rubric_categories, resolver: Queries::RubricCategoriesQuery

    field :category_indicator, resolver: Queries::CategoryIndicatorQuery
    field :category_indicators, resolver: Queries::CategoryIndicatorsQuery

    field :resource, resolver: Queries::ResourceQuery
    field :resources, resolver: Queries::ResourcesQuery
    field :resource_types, resolver: Queries::ResourceTypesQuery

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

    field :paginated_candidate_resources, resolver: Paginated::PaginatedCandidateResources
    field :pagination_attribute_candidate_resource, resolver: Paginated::PaginationAttributeCandidateResource

    field :paginated_countries, resolver: Paginated::PaginatedCountries
    field :pagination_attribute_country, resolver: Paginated::PaginationAttributeCountry

    field :paginated_sectors, resolver: Paginated::PaginatedSectors
    field :pagination_attribute_sector, resolver: Paginated::PaginationAttributeSector

    field :paginated_tags, resolver: Paginated::PaginatedTags
    field :pagination_attribute_tag, resolver: Paginated::PaginationAttributeTag

    field :paginated_workflows, resolver: Paginated::PaginatedWorkflows
    field :pagination_attribute_workflow, resolver: Paginated::PaginationAttributeWorkflow

    field :city, resolver: Queries::CityQuery
    field :cities, resolver: Queries::CitiesQuery
    field :paginated_cities, resolver: Paginated::PaginatedCities
    field :pagination_attribute_city, resolver: Paginated::PaginationAttributeCity

    field :contact, resolver: Queries::ContactQuery
    field :contacts, resolver: Queries::ContactsQuery
    field :hub_contact, resolver: Queries::UserContactQuery
    field :hub_contacts, resolver: Queries::HubContactsQuery
    field :paginated_contacts, resolver: Paginated::PaginatedContacts
    field :pagination_attribute_contact, resolver: Paginated::PaginationAttributeContact

    field :paginated_opportunities, resolver: Paginated::PaginatedOpportunities
    field :pagination_attribute_opportunity, resolver: Paginated::PaginationAttributeOpportunity

    field :paginated_resources, resolver: Paginated::PaginatedResources
    field :pagination_attribute_resource, resolver: Paginated::PaginationAttributeResource

    field :paginated_playbooks, resolver: Paginated::PaginatedPlaybooks
    field :pagination_attribute_playbook, resolver: Paginated::PaginationAttributePlaybook

    field :paginated_users, resolver: Paginated::PaginatedUsers
    field :pagination_attribute_user, resolver: Paginated::PaginationAttributeUser

    field :owners, resolver: Queries::OwnersQuery
    field :bookmark, resolver: Queries::BookmarkQuery

    field :task_tracker, resolver: Queries::TaskTrackerQuery
    field :task_trackers, resolver: Queries::TaskTrackersQuery
    field :paginated_task_trackers, resolver: Paginated::PaginatedTaskTrackers
    field :pagination_attribute_task_tracker, resolver: Paginated::PaginationAttributeTaskTracker

    field :region, resolver: Queries::RegionQuery
    field :regions, resolver: Queries::RegionsQuery
    field :paginated_regions, resolver: Paginated::PaginatedRegions
    field :pagination_attribute_region, resolver: Paginated::PaginationAttributeRegion

    field :sync, resolver: Queries::SyncQuery
    field :syncs, resolver: Queries::SyncsQuery
    field :paginated_syncs, resolver: Paginated::PaginatedSyncs
    field :pagination_attribute_sync, resolver: Paginated::PaginationAttributeSync

    field :starred_object, resolver: Queries::StarredObjectQuery
    field :starred_objects, resolver: Queries::StarredObjectsQuery

    field :author, resolver: Queries::AuthorQuery
    field :authors, resolver: Queries::AuthorsQuery

    field :resource_topic, resolver: Queries::ResourceTopicQuery
    field :resource_topics, resolver: Queries::ResourceTopicsQuery
    field :resource_topic_resources, resolver: Queries::ResourceTopicResourcesQuery

    field :paginated_resource_topics, resolver: Paginated::PaginatedResourceTopics
    field :pagination_attribute_resource_topic, resolver: Paginated::PaginationAttributeResourceTopic

    field :chatbot_conversations, resolver: Queries::ChatbotConversationsQuery
    field :chatbot_conversation_starters, resolver: Queries::ChatbotConversationStartersQuery

    field :message, resolver: Queries::MessageQuery
    field :messages, resolver: Queries::MessagesQuery
    field :paginated_messages, resolver: Paginated::PaginatedMessages
    field :pagination_attribute_message, resolver: Paginated::PaginationAttributeMessage

    field :software_category, resolver: Queries::SoftwareCategoryQuery
    field :software_categories, resolver: Queries::SoftwareCategoriesQuery

    field :software_feature, resolver: Queries::SoftwareFeatureQuery
    field :software_features, resolver: Queries::SoftwareFeaturesQuery

    field :site_setting, resolver: Queries::SiteSettingQuery
    field :site_settings, resolver: Queries::SiteSettingsQuery
    field :default_site_setting, resolver: Queries::DefaultSiteSettingQuery
    field :paginated_site_settings, resolver: Paginated::PaginatedSiteSettings
    field :pagination_attribute_site_setting, resolver: Paginated::PaginationAttributeSiteSetting

    field :tenant_setting, resolver: Queries::TenantSettingQuery
    field :tenant_settings, resolver: Queries::TenantSettingsQuery

    field :candidate_status, resolver: Queries::CandidateStatusQuery
    field :candidate_statuses, resolver: Queries::CandidateStatusesQuery
    field :initial_candidate_statuses, resolver: Queries::InitialCandidateStatusesQuery
    field :paginated_candidate_statuses, resolver: Paginated::PaginatedCandidateStatuses
    field :pagination_attribute_candidate_status, resolver: Paginated::PaginationAttributeCandidateStatus
  end
end
