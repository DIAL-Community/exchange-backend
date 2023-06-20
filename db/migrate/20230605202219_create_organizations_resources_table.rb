# frozen_string_literal: true

class CreateOrganizationsResourcesTable < ActiveRecord::Migration[7.0]
  def change
    create_table(:organizations_resources) do |t|
      t.bigint('organization_id', null: false)
      t.bigint('resource_id', null: false)
      t.index(%w[organization_id resource_id], name: 'organizations_resources_idx', unique: true)
      t.index(%w[resource_id organization_id], name: 'resources_organizations_idx', unique: true)
    end

    add_foreign_key('organizations_resources', 'resources', name: 'organizations_resources_resource_fk')
    add_foreign_key('organizations_resources', 'organizations', name: 'organizations_resources_organization_fk')
  end
end
