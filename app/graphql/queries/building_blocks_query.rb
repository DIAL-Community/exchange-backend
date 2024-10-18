# frozen_string_literal: true

module Queries
  class BuildingBlocksQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::BuildingBlockType], null: false

    def resolve(search:)
      building_blocks = BuildingBlock.order(:name)
      building_blocks = building_blocks.name_contains(search) unless search.blank?
      validate_access_to_resource(building_blocks)
      building_blocks
    end
  end

  class BuildingBlockQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::BuildingBlockType, null: true

    def resolve(slug:)
      building_block = BuildingBlock.find_by(slug:)
      validate_access_to_resource(building_block)
      building_block
    end
  end
end
