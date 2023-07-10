# frozen_string_literal: true

module Mutations
  class AddBookmark < Mutations::BaseMutation
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
        current_product = Product.find_by(id: data.to_i)
        current_saved << current_product.id unless current_product.nil?
        current_user.saved_products = current_saved.uniq
      elsif type == 'BUILDING-BLOCK'
        current_saved = current_user.saved_building_blocks
        current_building_block = BuildingBlock.find_by(id: data.to_i)
        current_saved << current_building_block.id unless current_building_block.nil?
        current_user.saved_building_blocks = current_saved.uniq
      elsif type == 'USE-CASE'
        current_saved = current_user.saved_use_cases
        current_use_case = UseCase.find_by(id: data.to_i)
        current_saved << current_use_case.id unless current_use_case.nil?
        current_user.saved_use_cases = current_saved.uniq
      elsif type == 'URL'
        current_saved = current_user.saved_urls
        current_saved << data unless validate_url.nil?
        current_user.saved_urls = current_saved.uniq
      end

      if current_user.save
        { bookmark: current_user, errors: [] }
      else
        { bookmark: nil, errors: current_user.errors.full_messages }
      end
    end

    def validate_url(current_url)
      acceptable_url_parts = [
        '/ui/v1/building-blocks',
        '/ui/v1/products',
        '/ui/v1/use-cases'
      ]
      acceptable_url_parts.index { |x| x.include?(current_url) }
    end
  end
end
