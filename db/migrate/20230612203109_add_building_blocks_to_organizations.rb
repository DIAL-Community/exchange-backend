# frozen_string_literal: true

class AddBuildingBlocksToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column(:organizations, :building_blocks, :jsonb, null: false, default: [])
  end
end
