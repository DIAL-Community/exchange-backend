# frozen_string_literal: true

class CreateResourceTopicDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table(:resource_topic_descriptions) do |t|
      t.string(:locale, null: false)
      t.string(:description, null: false)
      t.references(:resource_topic, null: false, foreign_key: true)

      t.index(%i[resource_topic_id locale], unique: true, name: 'unique_on_resource_topic_id_and_locale')

      t.timestamps
    end
  end
end
