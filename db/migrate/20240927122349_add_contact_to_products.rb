# frozen_string_literal: true
class AddContactToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column(:products, :contact, :string)
  end

  def down
    remove_column(:products, :contact, :string)
  end
end
