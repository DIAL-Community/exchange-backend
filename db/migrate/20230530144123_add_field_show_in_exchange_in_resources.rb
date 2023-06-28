# frozen_string_literal: true

class AddFieldShowInExchangeInResources < ActiveRecord::Migration[7.0]
  def change
    add_column(:resources, :show_in_exchange, :boolean, null: false, default: false)
  end
end
