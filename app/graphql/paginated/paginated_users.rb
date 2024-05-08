# frozen_string_literal: true

module Paginated
  class PaginatedUsers < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :roles, [String], required: false, default_value: []

    argument :offset_attributes, Attributes::OffsetAttributes, required: true

    type [Types::UserType], null: false

    def resolve(search:, roles:, offset_attributes:)
      if !unsecure_read_allowed && context[:current_user].nil?
        return []
      end

      return [] unless an_admin

      users = User.order(:email)
      unless search.blank?
        users = users.name_contains(search)
      end

      filtered_roles = roles.reject { |x| x.nil? || x.empty? }
      unless filtered_roles.empty?
        users = users.where('roles && ARRAY[?]::user_role[]', filtered_roles)
      end

      offset_params = offset_attributes.to_h
      users.limit(offset_params[:limit]).offset(offset_params[:offset])
    end
  end
end
