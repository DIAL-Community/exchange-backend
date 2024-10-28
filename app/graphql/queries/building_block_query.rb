# frozen_string_literal: true

module Queries
  class BuildingBlockQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::BuildingBlockType, null: true

    def resolve(slug:)
      building_block = BuildingBlock.find_by(slug:) if valid_slug?(slug)
      # Validate access to the current object or entity type.
      validate_access_to_instance(building_block || BuildingBlock.new)
      # TODO: Need to group the permission request with the original data request.
      # Currently it is sending separate graph query. We need to reply with the error
      # if the original request also include permission checking in the header of the
      # request.
      #
      # Adding multiple graph error along with the graph data:
      # context.add_error(
      #   GraphQL::ExecutionError.new(
      #     'Editing is not allowed.',
      #     extensions: { 'code' => NO_EDITING }
      #   )
      # )
      # context.add_error(
      #   GraphQL::ExecutionError.new(
      #     'Deleting is not allowed.',
      #     extensions: { 'code' => NO_DELETING }
      #   )
      # )

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
