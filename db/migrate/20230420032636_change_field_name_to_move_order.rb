# frozen_string_literal: true

class ChangeFieldNameToMoveOrder < ActiveRecord::Migration[6.1]
  def up
    rename_column(:play_moves, :order, :move_order)
    rename_column(:playbook_plays, :order, :play_order)
    change_column(:playbook_plays, :play_order, :integer, null: false, default: 0)
    change_column(:play_moves, :move_order, :integer, null: false, default: 0)
  end

  def down
    rename_column(:play_moves, :move_order, :order)
    rename_column(:playbook_plays, :play_order, :order)
  end
end
