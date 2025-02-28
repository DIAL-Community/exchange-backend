# frozen_string_literal: true

module Mutations
  class DeleteUser < Mutations::BaseMutation
    argument :id, ID, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      user = User.find_by(id:)
      user_policy = Pundit.policy(context[:current_user], user || User.new)
      if user.nil? || !user_policy.delete_allowed?
        return {
          user: nil,
          errors: ['Deleting user is not allowed.']
        }
      end

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
