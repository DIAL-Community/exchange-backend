# frozen_string_literal: true

module Queries
  class BuildingBlocksQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::BuildingBlockType], null: false

    def resolve(search:)
      building_blocks = BuildingBlock.order(:name)
      building_blocks = building_blocks.name_contains(search) unless search.blank?
      building_blocks
    end
  end

  class BuildingBlockQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::BuildingBlockType, null: true

    def resolve(slug:)
      BuildingBlock.find_by(slug:)
    end
  end
end
