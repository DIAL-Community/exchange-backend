# frozen_string_literal: true

class AddExtendedDataToContactsTable < ActiveRecord::Migration[7.0]
  def change
    add_column(:contacts, :extended_data, :jsonb, default: [])
  end
end
