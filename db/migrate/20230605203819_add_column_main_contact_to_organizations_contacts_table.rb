# frozen_string_literal: true

class AddColumnMainContactToOrganizationsContactsTable < ActiveRecord::Migration[7.0]
  def change
    add_column(:organizations_contacts, :main_contact, :boolean, null: false, default: false)
  end
end
