# frozen_string_literal: true

class AddItemConfigurationsAndItemLayoutsToSiteSettings < ActiveRecord::Migration[7.0]
  def change
    add_column(:site_settings, :item_layouts, :jsonb, null: false, default: {})
    add_column(:site_settings, :item_configurations, :jsonb, null: false, default: {})
  end
end
