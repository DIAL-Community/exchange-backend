# frozen_string_literal: true

module Paginated
  class PaginatedUsers < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :offset_attributes, Attributes::OffsetAttributes, required: true
    type [Types::UserType], null: false

    def resolve(search:, offset_attributes:)
      return [] unless an_admin

      users = User.order(:email)
      unless search.blank?
        users = users.name_contains(search)
      end

      offset_params = offset_attributes.to_h
      users.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
