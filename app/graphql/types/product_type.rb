# frozen_string_literal: true

module Types
  class ProductDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :product_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class EndorserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
  end

  class ProductType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false
    field :website, String, null: true
    field :aliases, GraphQL::Types::JSON, null: true
    field :tags, GraphQL::Types::JSON, null: true
    field :extra_attributes, [GraphQL::Types::JSON], null: true
    field :product_stage, String, null: true

    # TODO: Deprecate this field after migration to the new UI
    field :owner, String, null: true
    field :is_launchable, Boolean, null: true

    field :have_owner, Boolean, null: false
    def have_owner
      !User.find_by('? = ANY(user_products)', object&.id).nil?
    end

    field :languages, GraphQL::Types::JSON, null: true
    field :gov_stack_entity, Boolean, null: false
    field :product_type, String, null: false

    field :main_repository, Types::ProductRepositoryType, null: true
    field :sectors, [Types::SectorType], null: true, method: :sectors_localized
    field :countries, [Types::CountryType], null: true
    def countries
      object.countries&.order(:name)
    end

    field :product_descriptions, [Types::ProductDescriptionType], null: true
    field :product_description, Types::ProductDescriptionType, null: true,
      method: :product_description_localized

    field :parsed_description, String, null: true
    def parsed_description
      return if object.product_description_localized.nil?

      object_description = object.product_description_localized.description
      first_paragraph = Nokogiri::HTML.fragment(object_description).at('p')
      first_paragraph.nil? ? object_description : first_paragraph.inner_html
    end

    field :origins, [Types::OriginType], null: true
    field :endorsers, [Types::EndorserType], null: true
    field :organizations, [Types::OrganizationType], null: true

    field :resources, [Types::ResourceType], null: true

    field :software_categories, [Types::SoftwareCategoryType], null: true
    field :software_features, [Types::SoftwareFeatureType], null: true

    field :current_projects, [Types::ProjectType], null: true do
      argument :first, Integer, required: false
    end

    field :product_indicators, [Types::ProductIndicatorType], null: true
    field :not_assigned_category_indicators, [Types::CategoryIndicatorType], null: true

    field :projects, [Types::ProjectType], null: true

    field :building_blocks, [Types::BuildingBlockType], null: true
    field :building_blocks_mapping_status, String, method: :building_blocks_mapping_status

    field :sustainable_development_goals, [Types::SustainableDevelopmentGoalType], null: true
    field :sustainable_development_goals_mapping_status, String,
      method: :sustainable_development_goals_mapping_status

    field :sdgs, [Types::SustainableDevelopmentGoalType], null: true
    field :sdgs_mapping_status, String, null: true, method: :sustainable_development_goals_mapping_status
    def sdgs
      object.sustainable_development_goals&.order(:number)
    end

    field :interoperates_with, [Types::ProductType], null: true
    field :includes, [Types::ProductType], null: true

    field :overall_maturity_score, Float, null: true
    field :maturity_score_details, GraphQL::Types::JSON, null: true

    field :manual_update, Boolean, null: false

    field :commercial_product, Boolean, null: false
    field :pricing_model, String, null: true
    field :pricing_details, String, null: true
    field :hosting_model, String, null: true

    field :is_linked_with_dpi, Boolean, null: false, method: :is_linked_with_dpi

    field :playbooks, [Types::PlaybookType], null: true
  end
end
