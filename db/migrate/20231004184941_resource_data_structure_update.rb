# frozen_string_literal: true

class ResourceDataStructureUpdate < ActiveRecord::Migration[7.0]
  def change
    create_table(:authors, force: :cascade) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false, index: { unique: true, name: 'authors_unique_slug' })

      t.string(:email, null: true)
      t.string(:picture, null: false)

      t.timestamps
    end

    rename_column(:resources, :link, :resource_link)
    add_column(:resources, :link_desc, :string, null: true)

    add_column(:resources, :tags, :string, array: true, default: [])

    add_column(:resources, :resource_type, :string, null: true)
    add_column(:resources, :resource_topic, :string, null: true)

    add_column(:resources, :published_date, :datetime, null: true)
    add_column(:resources, :featured, :boolean, null: false, default: false)
    add_column(:resources, :spotlight, :boolean, null: false, default: false)

    add_column(:resources, :source, :string, null: true)

    create_join_table(:resources, :authors, table_name: 'resources_authors') do |t|
      t.index(:resource_id)
      t.index(:author_id)
    end

    create_join_table(:resources, :countries, table_name: 'resources_countries') do |t|
      t.index(:resource_id)
      t.index(:country_id)
    end
  end
end
