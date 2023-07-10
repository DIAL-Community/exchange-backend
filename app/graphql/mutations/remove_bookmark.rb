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
        current_saved = current_user.saved_products
        current_saved.delete_at(current_saved.find_index(data))
      elsif type == 'BUILDING-BLOCK'
        current_saved = current_user.saved_building_blocks
        current_saved.delete_at(current_saved.find_index(data))
      elsif type == 'USE-CASE'
        current_saved = current_user.saved_use_cases
        current_saved.delete_at(current_saved.find_index(data))
      elsif type == 'URL'
        current_saved = current_user.saved_urls
        current_saved.delete_at(current_saved.find_index(data))
      end

      if current_user.save
        { bookmark: current_user, errors: [] }
      else
        { bookmark: nil, errors: current_user.errors.full_messages }
      end
    end
  end
end
