# frozen_string_literal: true

class CreatePinnedRelationshipObjects < ActiveRecord::Migration[7.0]
  def change
    create_table(:starred_objects) do |t|
      t.string(:starred_object_type, null: false)
      t.string(:starred_object_value, null: false)
      t.string(:source_object_type, null: false)
      t.string(:source_object_value, null: false)

      t.references(:starred_by, index: true, foreign_key: { to_table: :users })
      t.datetime(:starred_date, null: false)

      t.index(
        %i[starred_object_type starred_object_value source_object_type source_object_value],
        name: "index_starred_object_record",
        unique: true
      )
      t.timestamps
    end
  end
end
