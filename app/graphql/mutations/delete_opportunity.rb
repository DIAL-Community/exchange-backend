# frozen_string_literal: true

module Mutations
  class DeleteOpportunity < Mutations::BaseMutation
    argument :id, ID, required: true

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      opportunity = Opportunity.find_by(id:)
      opportunity_policy = OpportunityPolicy.new(context[:current_user], opportunity || Opportunity.new)
      if opportunity.nil? || !opportunity_policy.delete_allowed?
        return {
          opportunity: nil,
          errors: ['Deleting opportunity is not allowed.']
        }
      end
      assign_auditable_user(opportunity)

      if opportunity.destroy
        # Successful deletion, return the deleted opportunity with no errors
        {
          opportunity:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          opportunity: nil,
          errors: opportunity.errors.full_messages
        }
      end
    end
  end
end
