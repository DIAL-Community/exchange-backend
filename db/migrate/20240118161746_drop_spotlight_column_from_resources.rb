# frozen_string_literal: true

class DropSpotlightColumnFromResources < ActiveRecord::Migration[7.0]
  def change
    remove_column(:resources, :spotlight, :boolean, null: false, default: false)
  end
end
