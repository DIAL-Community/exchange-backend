# frozen_string_literal: true

class CreateTenantSyncs < ActiveRecord::Migration[7.0]
  def change
    create_table(:tenant_syncs) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false)
      t.string(:description, null: false)

      t.string(:tenant_source, null: false)
      t.string(:tenant_destination, null: false)
      t.boolean(:sync_enabled, null: false, default: true)

      t.json(:sync_configuration, null: false, default: {})

      t.datetime(:last_sync_at)
      t.timestamps
    end
  end
end
