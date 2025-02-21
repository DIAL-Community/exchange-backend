# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingItemLayouts < Mutations::BaseMutation
    argument :item_layouts, GraphQL::Types::JSON, required: true, default_value: {}

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(item_layouts:)
      site_setting = SiteSetting.find_by(default_setting: true)
      site_setting_policy = Pundit.policy(context[:current_user], site_setting || SiteSetting.new)
      if site_setting.nil? || !site_setting_policy.edit_allowed?
        return {
          site_setting: nil,
          errors: ['Editing site setting is not allowed.']
        }
      end

      site_setting.item_layouts = { layouts: item_layouts }
      if site_setting.save
        # Successful creation, return the created object with no errors
        {
          site_setting:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          site_setting: nil,
          errors: site_setting.errors.full_messages
        }
      end
    end
  end
end
