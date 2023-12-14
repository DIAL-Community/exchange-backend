# frozen_string_literal: true

class AddRegionsTableToGroupCountries < ActiveRecord::Migration[7.0]
  def change
    create_table(:regions) do |t|
      t.string(:slug, null: false)
      t.string(:name, null: false)
      t.string(:description, null: false)
      t.string(:aliases, default: [], array: true)

      t.index(:slug, unique: true)
      t.timestamps
    end

    create_join_table(:regions, :countries, table_name: 'regions_countries') do |t|
      t.index(:region_id)
      t.index(:country_id)
    end
  end
end
