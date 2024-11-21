# frozen_string_literal: true

module Mutations
  class DeleteMessage < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, Types::MessageType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      message = Message.find_by(id:)
      message_policy = MessagePolicy.new(context[:current_user], message || Message.new)
      if message.nil? || !message_policy.delete_allowed?
        return {
          message: nil,
          errors: ['Deleting message is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        message.destroy!
        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted message with no errors
        {
          message:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          message: nil,
          errors: message.errors.full_messages
        }
      end
    end
  end
end
