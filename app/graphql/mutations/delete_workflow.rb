# frozen_string_literal: true

module Mutations
  class DeleteWorkflow < Mutations::BaseMutation
    argument :id, ID, required: true

    field :workflow, Types::WorkflowType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      workflow = Workflow.find_by(id:)
      workflow_policy = Pundit.policy(context[:current_user], workflow || Workflow.new)
      if workflow.nil? || !workflow_policy.delete_allowed?
        return {
          workflow: nil,
          errors: ['Deleting workflow is not allowed.']
        }
      end

      assign_auditable_user(workflow)
      if workflow.destroy
        # Successful deletion, return the deleted workflow with no errors
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
