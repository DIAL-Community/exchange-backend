# frozen_string_literal: true

class AddSubmittedByColumnToResources < ActiveRecord::Migration[7.0]
  def change
    add_reference(:resources, :submitted_by, null: true, foreign_key: { to_table: :users })
  end
end
