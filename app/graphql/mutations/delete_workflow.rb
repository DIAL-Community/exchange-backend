# frozen_string_literal: true

module Mutations
  class DeleteWorkflow < Mutations::BaseMutation
    argument :id, ID, required: true

    field :workflow, Types::WorkflowType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          workflow: nil,
          errors: ['Must be admin to delete a workflow.']
        }
      end

      workflow = Workflow.find_by(id:)
      assign_auditable_user(workflow)
      if workflow.destroy
        # Successful deletion, return the nil workflow with no errors
        {
          workflow:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          workflow: nil,
          errors: workflow.errors.full_messages
        }
      end
    end
  end
end
