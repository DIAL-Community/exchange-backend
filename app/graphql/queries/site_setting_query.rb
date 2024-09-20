# frozen_string_literal: true

module Queries
  class SiteSettingQuery < Queries::BaseQuery
    type Types::SiteSettingType, null: true

    def resolve
      return nil unless an_admin

      SiteSetting.find_by(default_settings: true)
    end
  end

  class SiteSettingsQuery < Queries::BaseQuery
    type [Types::SiteSettingType], null: true

    def resolve
      return [] unless an_admin

      SiteSetting.all
    end
  end
end
