# frozen_string_literal: true

module Queries
  class SiteSettingQuery < Queries::BaseQuery
    argument :slug, String, required: false, default_value: nil
    type Types::SiteSettingType, null: true

    def resolve(slug:)
      return nil unless an_admin

      return SiteSetting.find_by(slug:) unless slug.nil?
      site_settings = SiteSetting.order(updated_at: :desc)
      site_settings.find_by(default_setting: true) || site_settings.first
    end
  end

  class SiteSettingsQuery < Queries::BaseQuery
    type [Types::SiteSettingType], null: true

    def resolve
      return [] unless an_admin

      SiteSetting.all
    end
  end

  class DefaultSiteSettingQuery < Queries::BaseQuery
    type Types::SiteSettingType, null: true

    def resolve
      SiteSetting.find_by(default_setting: true) || SiteSetting.first
    end
  end
end
