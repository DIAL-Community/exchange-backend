# frozen_string_literal: true

module Types
  class UseCaseDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :use_case_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class UseCaseHeaderType < Types::BaseObject
    field :id, ID, null: false
    field :use_case_id, Integer, null: true
    field :locale, String, null: false
    field :header, String, null: false
  end

  class UseCaseType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: true
    field :maturity, String, null: false
    field :markdown_url, String, null: true

    field :use_case_descriptions, [Types::UseCaseDescriptionType], null: true
    field :use_case_description, Types::UseCaseDescriptionType, null: false,
                                                                method: :use_case_description_localized

    field :use_case_steps, [Types::UseCaseStepType], null: true

    field :use_case_headers, [Types::UseCaseHeaderType], null: true

    field :sdg_targets, [Types::SustainableDevelopmentGoalTargetType], null: false
    def sdg_targets
      object.sdg_targets&.order(:sdg_number)&.order(:target_number)
    end

    field :building_blocks, [Types::BuildingBlockType], null: true
    field :workflows, [Types::WorkflowType], null: true
    field :tags, GraphQL::Types::JSON, null: true
    field :sector, Types::SectorType, null: false
  end
end
