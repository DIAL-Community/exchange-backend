# frozen_string_literal: true

class ChangeDefaultValueForResource < ActiveRecord::Migration[7.0]
  def up
    change_column_default(:resources, :show_in_exchange, false)
    change_column_default(:resources, :show_in_wizard, false)
  end

  def down
    change_column_default(:resources, :show_in_exchange, false)
    change_column_default(:resources, :show_in_wizard, false)
  end
end
