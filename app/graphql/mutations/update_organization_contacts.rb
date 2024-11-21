# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class UpdateOrganizationContacts < Mutations::BaseMutation
    include Modules::Slugger

    argument :contacts, GraphQL::Types::JSON, required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(contacts:, slug:)
      organization = Organization.find_by(slug:)
      organization_policy = Pundit.policy(context[:current_user], organization || Organization.new)
      if organization.nil? || !organization_policy.edit_allowed?
        return {
          organization: nil,
          errors: ['Editing organization is not allowed.']
        }
      end

      organization.contacts = []
      if !contacts.nil? && !contacts.empty?
        contacts.each do |contact|
          current_contact = Contact.find_by(email: contact['email'])
          if current_contact.nil?
            current_contact = create_new_contact(contact['name'], contact['email'], contact['title'])
          end
          organization.contacts << current_contact
        end
      end

      if organization.save
        # Successful creation, return the created object with no errors
        {
          organization:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          organization: nil,
          errors: organization.errors.full_messages
        }
      end
    end

    def create_new_contact(name, email, title)
      contact = Contact.new(name:, email:, title:)
      contact.slug = reslug_em(name)

      if Contact.where(slug: contact.slug).count.positive?
        # Check if we need to add _dup to the slug.
        first_duplicate = Contact.slug_simple_starts_with(contact.slug)
                                 .order(slug: :desc)
                                 .first
        contact.slug = contact.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
      end

      contact
    end
  end
end
