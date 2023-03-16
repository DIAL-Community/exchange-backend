# frozen_string_literal: true

class DropLinkTypeFromProductBuildingBlocks < ActiveRecord::Migration[6.1]
  def change
    remove_column(:product_building_blocks, :link_type, :string, default: 'BETA')
  end
end
