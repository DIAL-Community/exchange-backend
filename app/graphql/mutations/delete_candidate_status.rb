# frozen_string_literal: true

module Mutations
  class DeleteCandidateStatus < Mutations::BaseMutation
    argument :id, ID, required: true

    field :candidate_status, Types::CandidateStatusType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          candidate_status: nil,
          errors: ['Must be admin to delete a candidate status.']
        }
      end

      candidate_status = CandidateStatus.find_by(id:)
      assign_auditable_user(candidate_status)
      if candidate_status.destroy
        # Successful deletion, return the deleted candidate_status with no errors
        {
          candidate_status:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          candidate_status: nil,
          errors: candidate_status.errors.full_messages
        }
      end
    end
  end
end
