# frozen_string_literal: true

module Mutations
  class UpdateMessageVisibility < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :visibility, Boolean, required: true

    field :message, Types::MessageType, null: true
    field :errors, [String], null: true

    def resolve(slug:, visibility:)
      message = Message.find_by(slug:)
      message_policy = Pundit.policy(context[:current_user], message || Message.new)
      if message.nil? || !message_policy.edit_allowed?
        return {
          message: nil,
          errors: ['Editing message is not allowed.']
        }
      end

      message.visible = visibility

      if message.save
        # Successful creation, return the created object with no errors
        {
          message:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          message: nil,
          errors: message.errors.full_messages
        }
      end
    end
  end
end
