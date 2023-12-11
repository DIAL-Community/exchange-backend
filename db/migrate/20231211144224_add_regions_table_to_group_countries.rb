# frozen_string_literal: true

class AddRegionsTableToGroupCountries < ActiveRecord::Migration[7.0]
  def change
    create_table(:regions) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false)
      t.string(:description, null: false)
      t.string(:aliases, default: [], array: true)

      t.index(:slug, unique: true)
      t.timestamps
    end

    add_reference(:countries, :region, column: :region_id, index: true)
  end
end
