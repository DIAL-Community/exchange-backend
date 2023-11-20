# frozen_string_literal: true
class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table(:exchange_tenants) do |t|
      t.string(:tenant_name)
      t.string(:domain)
      t.jsonb(:postgres_config)
      t.timestamps
    end
  end
end
