# frozen_string_literal: true

module Queries
  class ContactsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ContactType], null: false

    def resolve(search:)
      return [] unless an_admin

      contacts = Contact.order(:name)
      contacts = contacts.name_contains(search) unless search.blank?
      contacts
    end
  end

  class HubContactsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ContactType], null: false

    def resolve(search:)
      contacts = Contact.order(:name)
      contacts = contacts.name_contains(search) unless search.blank?
      contacts.where(source: DPI_TENANT_NAME)
    end
  end

  class ContactQuery < Queries::BaseQuery
    argument :slug, String, required: true
    argument :source, String, required: true, default_value: 'exchange'

    type Types::ContactType, null: true

    def resolve(slug:, source:)
      # Only logged in user can execute this graph query.
      return nil if context[:current_user].nil?

      current_user_slug = context[:current_user].slug
      # Prevent accessing other contact if the current context is not an admin user.
      return nil if !an_admin && !an_adli_admin && current_user_slug != slug

      Contact.find_by(slug:, source:)
    end
  end

  class UserContactQuery < Queries::BaseQuery
    # User and contact object connected using the email field.
    argument :email, String, required: true
    argument :source, String, required: true, default_value: 'exchange'

    type Types::ContactType, null: true

    def resolve(email:, source:)
      # Only logged in user can execute this graph query.
      return nil if context[:current_user].nil?

      current_user_email = context[:current_user].email
      # Prevent accessing other contact if the current context is not an admin user.
      return nil if !an_admin && !an_adli_admin && current_user_email != email

      Contact.find_by(email:, source:)
    end
  end
end
