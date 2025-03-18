# frozen_string_literal: true

class AddSectionConfigurationsToSiteSettings < ActiveRecord::Migration[7.1]
  def change
    add_column(:site_settings, :section_configurations, :jsonb, null: false, default: [])
  end
end
