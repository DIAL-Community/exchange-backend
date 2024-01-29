# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateContact < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :email, String, required: true
    argument :title, String, required: false, default_value: nil

    field :contact, Types::ContactType, null: true
    field :errors, [String], null: true

    def resolve(name:, email:, title:, slug:)
      unless an_admin
        return {
          contact: nil,
          errors: ['Must be an admin to create / edit a contact']
        }
      end

      # Prevent duplicating contact by the name of the contact.
      contact = Contact.find_by(slug:)
      contact = Contact.find_by(email:) if contact.nil?
      contact = Contact.new(name:, email:, title:, slug: reslug_em(name)) if contact.nil?

      successful_operation = false
      ActiveRecord::Base.transaction do
        contact.name = name
        contact.email = email
        contact.title = title

        assign_auditable_user(contact)
        contact.save!

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          contact:,
          errors: []
        }
      else
        # Failed save, return the errors to the client.
        # We will only reach this block if the transaction is failed.
        {
          contact: nil,
          errors: contact.errors.full_messages
        }
      end
    end
  end
end
