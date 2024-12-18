# frozen_string_literal: true

module Mutations
  class DeleteContact < Mutations::BaseMutation
    argument :id, ID, required: true

    field :contact, Types::ContactType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      contact = Contact.find_by(id:)
      contact_policy = Pundit.policy(context[:current_user], contact || Contact.new)
      if contact.nil? || !contact_policy.delete_allowed?
        return {
          contact: nil,
          errors: ['Deleting contact is not allowed.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(contact)
        contact.destroy!
        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the deleted contact with no errors
        {
          contact:,
          errors: []
        }
      else
        # Failed delete, return the errors to the client.
        {
          contact: nil,
          errors: contact.errors.full_messages
        }
      end
    end
  end
end
