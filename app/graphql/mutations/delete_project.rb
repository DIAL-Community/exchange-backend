# frozen_string_literal: true

module Mutations
  class DeleteProject < Mutations::BaseMutation
    argument :id, ID, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          dataset: nil,
          errors: ['Must be admin to delete a project.']
        }
      end

      project = Project.find_by(id:)
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
