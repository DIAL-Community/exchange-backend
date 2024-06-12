# frozen_string_literal: true

class AddTenantColumnToPlaybooks < ActiveRecord::Migration[7.0]
  def change
    add_column(:plays, :owned_by, :string, default: 'public')
    add_column(:playbooks, :owned_by, :string, default: 'public')
  end
end
