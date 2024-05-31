# frozen_string_literal: true

class CreateMessagesTable < ActiveRecord::Migration[7.0]
  def change
    create_table(:messages) do |t|
      t.string(:name, null: false)
      t.string(:slug, unique: true, null: false)

      t.string(:message_type, null: false)
      t.string(:message_template, null: false)
      t.datetime(:message_datetime, null: false)
      t.boolean(:visible, null: false, default: false)

      t.string(:location, null: true)
      t.string(:location_type, null: true)

      t.references(:created_by, null: false, index: true, foreign_key: { to_table: :users })

      t.timestamps
    end
  end
end
