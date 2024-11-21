# frozen_string_literal: true

module Mutations
  class DeleteProject < Mutations::BaseMutation
    argument :id, ID, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      project = Project.find_by(id:)
      project_policy = Pundit.policy(context[:current_user], project || Project.new)
      if project.nil? || !project_policy.delete_allowed?
        return {
          dataset: nil,
          errors: ['Deleting project is not allowed.']
        }
      end

      assign_auditable_user(project)
      if project.destroy
        # Successful deletion, return the deleted dataset with no errors
        {
          project:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          project: nil,
          errors: project.errors.full_messages
        }
      end
    end
  end
end
