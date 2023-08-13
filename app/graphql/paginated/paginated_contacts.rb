# frozen_string_literal: true

module Paginated
  class PaginatedContacts < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::DatasetType], null: false

    def resolve(search:, offset_attributes:)
      contacts = Contact.order(:name)
      unless search.blank?
        contacts = contacts.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      contacts.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
