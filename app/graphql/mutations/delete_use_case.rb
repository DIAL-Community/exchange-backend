# frozen_string_literal: true

module Mutations
  class DeleteUseCase < Mutations::BaseMutation
    argument :id, ID, required: true

    field :use_case, Types::UseCaseType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          use_case: nil,
          errors: ['Must be admin to delete a use case.']
        }
      end

      use_case = UseCase.find_by(id:)
      assign_auditable_user(use_case)
      if use_case.destroy
        # Successful deletion, return the nil use_case with no errors
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
