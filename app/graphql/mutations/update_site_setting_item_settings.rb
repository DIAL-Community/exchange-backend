# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingItemSettings < Mutations::BaseMutation
    argument :item_layouts, GraphQL::Types::JSON, required: true, default_value: {}
    argument :item_configurations, GraphQL::Types::JSON, required: true, default_value: []

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(item_layouts:, item_configurations:)
      site_setting = SiteSetting.find_by(default_setting: true)
      site_setting_policy = Pundit.policy(context[:current_user], site_setting || SiteSetting.new)
      if site_setting.nil? || !site_setting_policy.edit_allowed?
        return {
          site_setting: nil,
          errors: ['Editing site setting is not allowed.']
        }
      end

      # Cleaning up list of items to avoid unused items in the database. Layout is the source of truth.
      #
      # We're doing the same cleanup in the frontend, but adding it in the backend as well.
      sanitized_item_configurations = []
      item_configurations.map do |item_configuration|
        item_id = item_configuration['id']

        found = false
        item_layouts.map do |_key, current_item_layout|
          current_item_layout.map do |item_layout|
            if item_layout['i'] == item_id
              sanitized_item_configurations << item_configuration
              found = true
            end
            break if found
          end
          break if found
        end
      end

      site_setting.item_layouts = { layouts: item_layouts }
      site_setting.item_configurations = { items: sanitized_item_configurations }
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
