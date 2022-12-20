# frozen_string_literal: true

class AddUserDatasetsField < ActiveRecord::Migration[6.1]
  def change
    add_column(:users, :user_datasets, :bigint, array: true, default: [])
  end
end
