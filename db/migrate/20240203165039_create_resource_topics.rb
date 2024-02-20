# frozen_string_literal: true

class CreateResourceTopics < ActiveRecord::Migration[7.0]
  def change
    create_table(:resource_topics) do |t|
      t.string(:slug, null: false)
      t.string(:name, null: false)

      t.index([:slug], unique: true)
      t.timestamps
    end
  end
end
