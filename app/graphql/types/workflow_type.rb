# frozen_string_literal: true

module Types
  class WorkflowDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :use_case_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class WorkflowType < Types::BaseObject
    include ActionView::Helpers::SanitizeHelper

    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false

    field :workflow_descriptions, [Types::WorkflowDescriptionType], null: false
    field :workflow_description,
      Types::WorkflowDescriptionType,
      null: true,
      method: :workflow_description_localized

    field :parsed_description, String, null: true
    def parsed_description
      return if object.workflow_description_localized.nil?

      object_description = object.workflow_description_localized.description
      strip_links(object_description)
    end

    field :use_cases, [Types::UseCaseType], null: false
    field :use_case_steps, [Types::UseCaseStepType], null: false
    field :building_blocks, [Types::BuildingBlockType], null: false

    def use_cases
      workflow_use_cases = []
      object.use_case_steps.each do |use_case_step|
        workflow_use_cases << use_case_step.use_case
      end
      workflow_use_cases.uniq.sort_by(&:name)
    end
  end
end
