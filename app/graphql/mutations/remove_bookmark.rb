# frozen_string_literal: true

module Mutations
  class RemoveBookmark < Mutations::BaseMutation
    argument :data, String, required: true
    argument :type, String, required: true

    field :bookmark, Types::BookmarkType, null: true
    field :errors, [String], null: true

    def resolve(data:, type:)
      if context[:current_user].nil?
        return {
          bookmark: nil,
          errors: ['Must be logged in to edit bookmark.']
        }
      end

      current_user = context[:current_user]
      if type == 'PRODUCT'
        update_query = <<~SQL
          saved_products = ARRAY_REMOVE(saved_products, :removed_data::bigint)
        SQL
      elsif type == 'BUILDING_BLOCK'
        update_query = <<~SQL
          saved_building_blocks = ARRAY_REMOVE(saved_building_blocks, :removed_data::bigint)
        SQL
      elsif type == 'USE_CASE'
        update_query = <<~SQL
          saved_use_cases = ARRAY_REMOVE(saved_use_cases, :removed_data::bigint)
        SQL
      elsif type == 'URL'
        update_query = <<~SQL
          saved_urls = ARRAY_REMOVE(saved_urls, :removed_data::varchar)
        SQL
      end

      update_sql = ActiveRecord::Base.sanitize_sql([update_query, { removed_data: data }])
      if User.where(id: current_user.id).update_all(update_sql).positive?
        { bookmark: User.find(current_user.id), errors: [] }
      else
        { bookmark: nil, errors: current_user.errors.full_messages }
      end
    end
  end
end
