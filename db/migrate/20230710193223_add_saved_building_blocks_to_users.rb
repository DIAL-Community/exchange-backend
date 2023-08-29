# frozen_string_literal: true

class AddSavedBuildingBlocksToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column(:users, :saved_building_blocks, :bigint, array: true, null: false, default: [])
  end
end
