# frozen_string_literal: true

module Queries
  class SiteSettingQuery < Queries::BaseQuery
    argument :slug, String, required: false, default_value: nil
    type Types::SiteSettingType, null: true

    def resolve(slug:)
      site_setting = SiteSetting.find_by(slug:) if valid_slug?(slug)
      validate_access_to_resource(site_setting || SiteSetting.new)
      site_setting
    end
  end

  class SiteSettingsQuery < Queries::BaseQuery
    type [Types::SiteSettingType], null: true

    def resolve
      validate_access_to_resource(SiteSetting.new)
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
