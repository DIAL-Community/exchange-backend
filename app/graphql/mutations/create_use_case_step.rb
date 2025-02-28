# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateUseCaseStep < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: false, default_value: nil
    argument :description, String, required: false, default_value: nil
    argument :step_number, Integer, required: true
    argument :use_case_id, Integer, required: true

    field :use_case_step, Types::UseCaseStepType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, description:, step_number:, use_case_id:)
      use_case = UseCase.find_by(id: use_case_id)
      use_case_policy = Pundit.policy(context[:current_user], use_case || UseCase.new)
      if use_case.nil? && !use_case_policy.create_allowed?
        return {
          use_case_step: nil,
          errors: ['Creating / editing use case step is not allowed.']
        }
      end

      if !use_case.nil? && !use_case_policy.edit_allowed?
        return {
          use_case_step: nil,
          errors: ['Creating / editing use case step is not allowed.']
        }
      end

      use_case_step = UseCaseStep.find_by(slug:)
      if use_case_step.nil?
        slug = reslug_em(name)
        use_case_step = UseCaseStep.new(name:, slug:)

        # Check if we need to add _dup to the slug.
        first_duplicate = UseCaseStep.slug_simple_starts_with(slug)
                                     .order(slug: :desc)
                                     .first
        unless first_duplicate.nil?
          use_case_step.slug += generate_offset(first_duplicate)
        end
      end

      # allow user to rename use case but don't re-slug it
      use_case_step.name = name
      use_case_step.use_case_id = use_case_id
      use_case_step.step_number = step_number

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(use_case_step)
        use_case_step.save!

        unless description.blank?
          use_case_step_desc = UseCaseStepDescription.find_by(id: use_case_step.id, locale: I18n.locale)
          use_case_step_desc = UseCaseStepDescription.new if use_case_step_desc.nil?
          use_case_step_desc.description = description
          use_case_step_desc.use_case_step_id = use_case_step.id
          use_case_step_desc.locale = I18n.locale

          assign_auditable_user(use_case_step_desc)
          use_case_step_desc.save!
        end

        successful_operation = true
      end

      if successful_operation
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
