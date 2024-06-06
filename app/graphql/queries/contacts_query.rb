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

  class ContactQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ContactType, null: true

    def resolve(slug:)
      return nil unless an_admin

      Contact.find_by(slug:)
    end
  end

  class ContactByEmailQuery < Queries::BaseQuery
    argument :email, String, required: true
    argument :source, String, required: true, default_value: 'exchange'

    type Types::ContactType, null: true

    def resolve(email:, source:)
      return nil unless an_admin

      Contact.find_by(email:, source:)
    end
  end
end
