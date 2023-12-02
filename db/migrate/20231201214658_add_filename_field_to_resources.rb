# frozen_string_literal: true

class AddFilenameFieldToResources < ActiveRecord::Migration[7.0]
  def change
    add_column(:resources, :resource_file, :string, null: true)
  end
end
