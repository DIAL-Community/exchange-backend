# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateContact < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :email, String, required: true
    argument :title, String, required: false, default_value: nil

    argument :source, String, required: true, default_value: 'exchange'
    argument :biography, String, required: false, default_value: nil
    argument :social_networking_services, GraphQL::Types::JSON, required: false, default_value: []

    field :contact, Types::ContactType, null: true
    field :errors, [String], null: true

    def resolve(name:, email:, title:, slug:, source:, biography:, social_networking_services:)
      contact_policy = Pundit.policy(context[:current_user], Contact.new)
      unless contact_policy.edit_allowed?
        return {
          contact: nil,
          errors: ['Must be an logged in to create / edit contact.']
        }
      end

      current_user_email = context[:current_user].email
      if !an_admin && !an_adli_admin && current_user_email != email
        return {
          contact: nil,
          errors: ['User only allowed to edit / create their own contact.']
        }
      end

      # Prevent duplicating contact by the name of the contact.
      contact = Contact.find_by(slug:)
      contact = Contact.find_by(email:) if contact.nil?
      contact = Contact.new(name:, email:, title:, slug: reslug_em("#{name}-#{email}")) if contact.nil?

      if contact.name != name
        contact.slug = reslug_em("#{name}-#{email}")
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        contact.name = name
        contact.email = email
        contact.title = title

        contact.biography = biography
        contact.source = source

        contact.social_networking_services = social_networking_services.each do |sns|
          sns['value'] = sns['value'].strip
                                     .sub(/^https?:\/\//i, '')
                                     .sub(/^https?\/\/:/i, '')
                                     .sub(/\/$/, '')
        end

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
