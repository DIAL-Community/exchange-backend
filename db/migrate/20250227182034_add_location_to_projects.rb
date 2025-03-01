# frozen_string_literal: true
class AddLocationToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column(:projects, :location, :string, null: true, default: nil)
    add_column(:projects, :latitude, :float, null: true, default: nil)
    add_column(:projects, :longitude, :float, null: true, default: nil)
  end
end
