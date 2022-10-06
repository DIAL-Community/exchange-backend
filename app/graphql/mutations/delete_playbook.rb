# frozen_string_literal: true

module Mutations
  class DeletePlaybook < Mutations::BaseMutation
    argument :id, ID, required: true

    field :playbook, Types::PlaybookType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          playbook: nil,
          errors: ['Must be admin to delete an playbook.']
        }
      end

      playbook = Playbook.find_by(id: id)
      if playbook.destroy
        # Successful deletion, return the nil playbook with no errors
        {
          playbook: playbook,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          playbook: nil,
          errors: playbook.errors.full_messages
        }
      end
    end
  end
end
