# frozen_string_literal: true

class DropOrganizationsStates < ActiveRecord::Migration[7.0]
  def change
    drop_table(:organizations_states)
  end
end
