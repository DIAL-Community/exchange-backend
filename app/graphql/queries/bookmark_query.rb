# frozen_string_literal: true

module Queries
  class BookmarkQuery < Queries::BaseQuery
    argument :id, ID, required: true

    type Types::BookmarkType, null: true

    def resolve(id:)
      current_user = context[:current_user]
      return current_user if current_user.id.to_i == id.to_i
    end
  end
end
