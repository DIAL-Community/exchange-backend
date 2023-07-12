# frozen_string_literal: true

module Mutations
  class DeleteOpportunity < Mutations::BaseMutation
    argument :id, ID, required: true

    field :opportunity, Types::OpportunityType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          opportunity: nil,
          errors: ['Must be admin to delete an opportunity']
        }
      end
      opportunity = Opportunity.find_by(id:)
      assign_auditable_user(opportunity)

      if opportunity.destroy
        # Successful deletetion, return the nil opportunity with no errors
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
