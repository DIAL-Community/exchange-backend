# frozen_string_literal: true

class CreateSiteSettings < ActiveRecord::Migration[7.0]
  def change
    create_table(:site_settings) do |t|
      t.string(:slug, null: false)
      t.string(:name, null: false)
      t.string(:description, null: false)

      t.string(:favicon_url, null: false)
      t.string(:exchange_logo_url, null: false)
      t.string(:open_graph_logo_url, null: false)

      t.jsonb(:menu_configurations, null: false, default: '[]')
      t.jsonb(:carousel_configurations, null: false, default: '[]')
      t.jsonb(:hero_card_configurations, null: false, default: '[]')

      t.boolean(:default_setting, null: false, default: false)
      t.boolean(:enable_marketplace, null: false, default: false)
      t.timestamps
    end
  end
end
