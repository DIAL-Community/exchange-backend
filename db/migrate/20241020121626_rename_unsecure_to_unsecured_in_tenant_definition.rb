# frozen_string_literal: true

class RenameUnsecureToUnsecuredInTenantDefinition < ActiveRecord::Migration[7.0]
  def change
    rename_column(:exchange_tenants, :allow_unsecure_read, :allow_unsecured_read)
  end
end
