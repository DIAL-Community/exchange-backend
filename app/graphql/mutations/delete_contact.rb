# frozen_string_literal: true

module Mutations
  class DeleteContact < Mutations::BaseMutation
    argument :id, ID, required: true

    field :contact, Types::ContactType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          contact: nil,
          errors: ['Must be admin to delete a contact.']
        }
      end

      contact = Contact.find_by(id:)
      if contact.nil?
        return {
          contact: nil,
          errors: ['Unable to uniquely identify contact to delete.']
        }
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        assign_auditable_user(contact)
        contact.destroy
        successful_operation = true
      end

      if successful_operation
        # Successful deletion, return the nil contact with no errors
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
