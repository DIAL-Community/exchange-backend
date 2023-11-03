# frozen_string_literal: true

class AddGovstackFieldTables < ActiveRecord::Migration[7.0]
  def change
    add_column(:building_blocks, :govstack_entity, :boolean, null: false, default: false)
    add_column(:opportunities, :govstack_entity, :boolean, null: false, default: false)
    add_column(:products, :govstack_entity, :boolean, null: false, default: false)
    add_column(:use_cases, :govstack_entity, :boolean, null: false, default: false)
  end
end
