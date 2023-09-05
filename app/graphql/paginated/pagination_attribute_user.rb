# frozen_string_literal: true

module Paginated
  class PaginationAttributeUser < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type Attributes::PaginationAttributes, null: false

    def resolve(search:)
      return { total_count: 0 } unless an_admin

      users = User.order(:name)
      unless search.blank?
        users = users.name_contains(search)
      end

      { total_count: users.count }
    end
  end
end
