# frozen_string_literal: true

class AddReferenceTablesForOpportunities < ActiveRecord::Migration[6.1]
  def change
    create_table(:opportunities_sectors, id: false, force: :cascade) do |t|
      t.references(:sector, index: true, foreign_key: true)
      t.references(:opportunity, index: true, foreign_key: true)
    end

    create_table(:opportunities_countries, id: false, force: :cascade) do |t|
      t.references(:country, index: true, foreign_key: true)
      t.references(:opportunity, index: true, foreign_key: true)
    end

    create_table(:opportunities_organizations, id: false, force: :cascade) do |t|
      t.references(:organization, index: true, foreign_key: true)
      t.references(:opportunity, index: true, foreign_key: true)
    end

    create_table(:opportunities_building_blocks, id: false, force: :cascade) do |t|
      t.references(:building_block, index: true, foreign_key: true)
      t.references(:opportunity, index: true, foreign_key: true)
    end

    create_table(:opportunities_use_cases, id: false, force: :cascade) do |t|
      t.references(:use_case, index: true, foreign_key: true)
      t.references(:opportunity, index: true, foreign_key: true)
    end
  end
end
