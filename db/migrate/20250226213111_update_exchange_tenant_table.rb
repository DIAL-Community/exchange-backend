# frozen_string_literal: true
class UpdateExchangeTenantTable < ActiveRecord::Migration[7.1]
  def change
    add_column(:exchange_tenants, :editable_landing, :boolean, default: false)
    add_column(:exchange_tenants, :tenant_country, :string, null: true, default: nil)
  end
end
