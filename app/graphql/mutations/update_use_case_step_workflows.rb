# frozen_string_literal: true

module Mutations
  class UpdateUseCaseStepWorkflows < Mutations::BaseMutation
    argument :workflow_slugs, [String], required: true
    argument :slug, String, required: true

    field :use_case_step, Types::UseCaseStepType, null: true
    field :errors, [String], null: true

    def resolve(workflow_slugs:, slug:)
      unless an_admin || a_content_editor
        return {
          use_case_step: nil,
          errors: ['Must be admin or content editor to update a use case step']
        }
      end

      use_case_step = UseCaseStep.find_by(slug:)

      use_case_step.workflows = []
      if !workflow_slugs.nil? && !workflow_slugs.empty?
        workflow_slugs.each do |workflow_slug|
          current_workflow = Workflow.find_by(slug: workflow_slug)
          use_case_step.workflows << current_workflow unless current_workflow.nil?
        end
      end

      if use_case_step.save
        # Successful creation, return the created object with no errors
        {
          use_case_step:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          use_case_step: nil,
          errors: use_case_step.errors.full_messages
        }
      end
    end
  end
end
