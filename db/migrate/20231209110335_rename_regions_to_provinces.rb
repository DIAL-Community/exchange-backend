# frozen_string_literal: true

class RenameRegionsToProvinces < ActiveRecord::Migration[7.0]
  def change
    rename_table(:regions, :provinces)

    rename_column(:cities, :region_id, :province_id)
    rename_column(:districts, :region_id, :province_id)
    rename_column(:offices, :region_id, :province_id)
  end
end
