# frozen_string_literal: true

class CreateRelationsOnResources < ActiveRecord::Migration[7.0]
  def change
    create_table(:resource_building_blocks) do |t|
      t.references(:resource, null: false, index: true, foreign_key: { to_table: :resources })
      t.references(:building_block, null: false, index: true, foreign_key: { to_table: :building_blocks })
      t.column(:mapping_status, :mapping_status_type, default: 'BETA')

      t.timestamps
    end
    add_index(
      :resource_building_blocks,
      [:resource_id, :building_block_id],
      unique: true,
      name: 'index_resource_building_blocks'
    )

    create_table(:resources_use_cases) do |t|
      t.references(:resource, null: false, foreign_key: { to_table: :resources })
      t.references(:use_case, null: false, foreign_key: { to_table: :use_cases })

      t.timestamps
    end
    add_index(
      :resources_use_cases,
      [:resource_id, :use_case_id],
      unique: true,
      name: 'index_resources_use_cases'
    )
  end
end
