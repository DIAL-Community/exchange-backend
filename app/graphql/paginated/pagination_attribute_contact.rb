# frozen_string_literal: true

module Paginated
  class PaginationAttributeContact < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(Contact.new)

      contacts = Contact.order(:name)
      unless search.blank?
        contacts = contacts.name_contains(search)
      end

      { total_count: contacts.count }
    end
  end
end
