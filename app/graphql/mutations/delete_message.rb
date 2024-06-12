# frozen_string_literal: true

module Mutations
  class DeleteMessage < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, Types::MessageType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin || an_adli_admin
        return {
          message: nil,
          errors: ['Must be admin to delete a message.']
        }
      end

      message = Message.find_by(id:)
      if message.nil?
        return {
          message: nil,
          errors: ['Unable to uniquely identify message to delete.']
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
