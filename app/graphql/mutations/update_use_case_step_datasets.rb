# frozen_string_literal: true

module Mutations
  class UpdateUseCaseStepDatasets < Mutations::BaseMutation
    argument :dataset_slugs, [String], required: true
    argument :slug, String, required: true

    field :use_case_step, Types::UseCaseStepType, null: true
    field :errors, [String], null: true

    def resolve(dataset_slugs:, slug:)
      use_case_step = UseCaseStep.find_by(slug:)
      use_case_step_policy = Pundit.policy(context[:current_user], use_case_step || UseCaseStep.new)
      if use_case_step.nil? || !use_case_step_policy.edit_allowed?
        return {
          use_case_step: nil,
          errors: ['Editing use case step is not allowed.']
        }
      end

      use_case_step.datasets = []
      if !dataset_slugs.nil? && !dataset_slugs.empty?
        dataset_slugs.each do |dataset_slug|
          current_dataset = Dataset.find_by(slug: dataset_slug)
          use_case_step.datasets << current_dataset unless current_dataset.nil?
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
