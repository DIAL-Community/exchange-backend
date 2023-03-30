# frozen_string_literal: true

class AddOrderFieldToBuildingBlocks < ActiveRecord::Migration[6.1]
  def change
    add_column(:building_blocks, :display_order, :integer, null: false, default: 0)
  end
end
