# frozen_string_literal: true

module Paginated
  class PaginationAttributeUser < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :roles, [String], required: false, default_value: []

    type Attributes::PaginationAttributes, null: false

    def resolve(search:, roles:)
      # Validate access to the current entity type.
      validate_access_to_resource(User.new)

      return { total_count: 0 } unless an_admin || an_adli_admin

      users = User.order(:name)
      unless search.blank?
        users = users.name_contains(search)
      end

      if an_adli_admin
        users = users.where('roles && ARRAY[?]::user_role[]', ['adli_admin', 'adli_user'])
      end

      filtered_roles = roles.reject { |x| x.nil? || x.empty? }
      unless filtered_roles.empty?
        users = users.where('roles && ARRAY[?]::user_role[]', filtered_roles)
      end

      { total_count: users.count }
    end
  end
end
