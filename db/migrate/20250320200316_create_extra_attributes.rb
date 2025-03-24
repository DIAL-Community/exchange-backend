# frozen_string_literal: true

class CreateExtraAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table(:extra_attributes) do |t|
      t.string(:name, null: false)
      t.string(:type, null: false)
      t.string(:title, null: false)
      t.string(:title_fallback)
      t.string(:description, null: false)
      t.string(:description_fallback)
      t.boolean(:required, null: false, default: false)
      t.boolean(:multiple, null: false, default: false)
      t.string(:options, null: false, array: true, default: [])
      t.string(:elements, null: false, array: true, default: [])

      t.timestamps
    end
    add_index(:extra_attributes, :name, unique: true)
  end
end
