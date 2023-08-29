# frozen_string_literal: true

module Paginated
  class PaginationAttributeContact < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''

    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      contacts = Contact.order(:name)
      unless search.blank?
        contacts = contacts.name_contains(search)
      end

      { total_count: contacts.count }
    end
  end
end
