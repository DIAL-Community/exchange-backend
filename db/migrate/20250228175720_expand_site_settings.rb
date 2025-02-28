class ExpandSiteSettings < ActiveRecord::Migration[7.1]
  def change
    add_column(:site_settings, :site_colors, :jsonb, null: false, default: {})
  end
end
