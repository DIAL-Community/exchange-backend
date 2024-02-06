# frozen_string_literal: true

class AddAllowUnsecureReadOnEntities < ActiveRecord::Migration[7.0]
  def change
    add_column(:exchange_tenants, :allow_unsecure_read, :boolean, null: false, default: true)
  end
end
