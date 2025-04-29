# frozen_string_literal: true

class CreateExtraAttributeDefinitions < ActiveRecord::Migration[7.1]
  def change
    create_table(:extra_attribute_definitions) do |t|
      t.string(:slug, null: false)
      t.string(:name, null: false)

      t.string(:attribute_type, null: false)
      t.boolean(:attribute_required, null: false, default: false)

      t.string(:title, null: false)
      t.string(:title_fallback)

      t.string(:description, null: false)
      t.string(:description_fallback)

      t.string(:entity_types, null: false, array: true, default: ['PRODUCT'])

      t.string(:choices, null: false, array: true, default: [])
      t.boolean(:multiple_choice, null: false, default: false)

      t.string(:elements, null: false, array: true, default: [])

      t.timestamps
    end
    add_index(:extra_attribute_definitions, :name, unique: true)
  end
end
