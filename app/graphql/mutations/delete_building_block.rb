# frozen_string_literal: true

module Mutations
  class DeleteBuildingBlock < Mutations::BaseMutation
    argument :id, ID, required: true

    field :building_block, Types::BuildingBlockType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          building_block: nil,
          errors: ['Must be admin to delete a building block.']
        }
      end

      building_block = BuildingBlock.find_by(id: id)
      assign_auditable_user(building_block)
      if building_block.destroy
        # Successful deletion, return the nil building_block with no errors
        {
          building_block: building_block,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          building_block: nil,
          errors: building_block.errors.full_messages
        }
      end
    end
  end
end
