class ChangePasswordField < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :encrypted_password, :password
  end
end
