# frozen_string_literal: true

module Mutations
  class DeleteBuildingBlock < Mutations::BaseMutation
    argument :id, ID, required: true

    field :building_block, Types::BuildingBlockType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      building_block = BuildingBlock.find_by(id:)
      building_block_policy = Pundit.policy(context[:current_user], building_block || BuildingBlock.new)
      unless building_block_policy.delete_allowed?
        return {
          building_block: nil,
          errors: ['Deleting building block is not allowed.']
        }
      end

      assign_auditable_user(building_block)
      if building_block.destroy
        # Successful deletion, return the deleted building_block with no errors
        {
          building_block:,
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
