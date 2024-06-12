# frozen_string_literal: true

class CreateUserMessages < ActiveRecord::Migration[7.0]
  def change
    create_table(:user_messages) do |t|
      t.references(:message, null: false, index: true, foreign_key: { to_table: :messages })
      t.references(:received_by, null: false, index: true, foreign_key: { to_table: :users })

      t.boolean(:read, null: false, default: false)
      t.boolean(:visible, null: false, default: false)

      t.timestamps
    end
  end
end
