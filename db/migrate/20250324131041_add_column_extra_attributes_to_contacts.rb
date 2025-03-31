# frozen_string_literal: true

class AddColumnExtraAttributesToContacts < ActiveRecord::Migration[7.1]
  def change
    add_column(:contacts, :extra_attributes, :jsonb, null: false, default: {})
  end
end
