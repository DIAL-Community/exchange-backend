# frozen_string_literal: true

class CreateResourceTypes < ActiveRecord::Migration[7.0]
  def change
    create_table(:resource_types) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false)
      t.string(:description, null: false)
      t.string(:locale, null: false, default: 'en')
      t.timestamps
    end
  end
end
