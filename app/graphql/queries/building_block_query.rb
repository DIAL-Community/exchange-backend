# frozen_string_literal: true

module Queries
  class BuildingBlockQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::BuildingBlockType, null: true

    def resolve(slug:)
      # Validate access to the current entity type.
      validate_access_to_resource(BuildingBlock.new)
      building_block = BuildingBlock.find_by(slug:) unless slug.blank?
      building_block
    end
  end

  class BuildingBlocksQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::BuildingBlockType], null: false

    def resolve(search:)
      # Validate access to the current entity type.
      validate_access_to_resource(BuildingBlock.new)
      building_blocks = BuildingBlock.order(:name)
      building_blocks = building_blocks.name_contains(search) unless search.blank?
      building_blocks
    end
  end
end
