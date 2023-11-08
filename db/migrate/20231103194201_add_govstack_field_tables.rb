# frozen_string_literal: true

class AddGovstackFieldTables < ActiveRecord::Migration[7.0]
  def change
    add_column(:building_blocks, :gov_stack_entity, :boolean, null: false, default: false)
    add_column(:opportunities, :gov_stack_entity, :boolean, null: false, default: false)
    add_column(:products, :gov_stack_entity, :boolean, null: false, default: false)
    add_column(:use_cases, :gov_stack_entity, :boolean, null: false, default: false)
  end
end
