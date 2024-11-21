# frozen_string_literal: true

module Mutations
  class UpdateUseCaseSdgTargets < Mutations::BaseMutation
    argument :sdg_target_ids, [Integer], required: true
    argument :slug, String, required: true

    field :use_case, Types::UseCaseType, null: true
    field :errors, [String], null: true

    def resolve(sdg_target_ids:, slug:)
      use_case = UseCase.find_by(slug:)
      use_case_policy = Pundit.policy(context[:current_user], use_case || UseCase.new)
      if use_case.nil? || !use_case_policy.edit_allowed?
        return {
          use_case: nil,
          errors: ['Editing use case is not allowed.']
        }
      end

      use_case.sdg_targets = []
      if !sdg_target_ids.nil? && !sdg_target_ids.empty?
        sdg_target_ids.each do |id|
          current_sdg_target = SdgTarget.find_by(id:)
          use_case.sdg_targets << current_sdg_target unless current_sdg_target.nil?
        end
      end

      if use_case.save
        # Successful creation, return the created object with no errors
        {
          use_case:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          use_case: nil,
          errors: use_case.errors.full_messages
        }
      end
    end
  end
end
