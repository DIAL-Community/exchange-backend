# frozen_string_literal: true

class RemoveRoleColumnFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column(:users, :role, :user_role)
  end
end
