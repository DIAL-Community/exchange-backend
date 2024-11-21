# frozen_string_literal: true

module Mutations
  class DeleteUseCase < Mutations::BaseMutation
    argument :id, ID, required: true

    field :use_case, Types::UseCaseType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      use_case = UseCase.find_by(id:)
      use_case_policy = Pundit.policy(context[:current_user], use_case || UseCase.new)
      if use_case.nil? || !use_case_policy.delete_allowed?
        return {
          use_case: nil,
          errors: ['Deleting use case is not allowed.']
        }
      end

      assign_auditable_user(use_case)
      if use_case.destroy
        # Successful deletion, return the deleted use_case with no errors
        {
          use_case:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          use_case: nil,
          errors: use_case.errors.full_messages
        }
      end
    end
  end
end
