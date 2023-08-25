# frozen_string_literal: true

module Mutations
  class DeleteUser < Mutations::BaseMutation
    argument :id, ID, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          user: nil,
          errors: ['Must be admin to delete a user.']
        }
      end

      user = User.find_by(id:)
      if user.destroy
        # Successful deletion, return the deleted user with no errors
        {
          user:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          user: nil,
          errors: user.errors.full_messages
        }
      end
    end
  end
end
