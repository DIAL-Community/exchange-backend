# frozen_string_literal: true

class UpdateSourceOnResourcesTable < ActiveRecord::Migration[7.0]
  def change
    remove_column(:resources, :source, :string)
    add_reference(:resources, :organization, foreign_key: { to_table: :organizations })
  end
end
