# frozen_string_literal: true

class DropOrganizationsStates < ActiveRecord::Migration[7.0]
  def change
    drop_table(:organizations_states) do |t|
      t.bigint('organization_id', null: false)
      t.bigint('region_id', null: false)
    end
  end
end
