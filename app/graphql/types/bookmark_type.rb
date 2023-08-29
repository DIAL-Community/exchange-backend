# frozen_string_literal: true

module Types
  class BookmarkType < Types::BaseObject
    field :id, ID, null: false

    field :bookmarked_products, [Types::ProductType], null: true
    def bookmarked_products
      Product.where(id: object.saved_products)
    end

    field :bookmarked_use_cases, [Types::UseCaseType], null: true
    def bookmarked_use_cases
      UseCase.where(id: object.saved_use_cases)
    end

    field :bookmarked_building_blocks, [Types::BuildingBlockType], null: true
    def bookmarked_building_blocks
      BuildingBlock.where(id: object.saved_building_blocks)
    end

    field :bookmarked_urls, [String], null: true
    def bookmarked_urls
      object.saved_urls
    end
  end
end
