# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingMenuConfigurations < Mutations::BaseMutation
    argument :site_setting_slug, String, required: true
    argument :menu_configurations, GraphQL::Types::JSON, required: true

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(site_setting_slug:, menu_configurations:)
      site_setting = SiteSetting.find_by(slug: site_setting_slug)
      site_setting_policy = Pundit.policy(context[:current_user], site_setting || SiteSetting.new)
      if site_setting.nil? || !site_setting_policy.edit_allowed?
        return {
          site_setting: nil,
          errors: ['Editing site setting is not allowed.']
        }
      end

      sanitized_menu_configurations = []
      menu_configurations.each do |menu_configuration|
        sanitized_menu_configuration = {
          'id': menu_configuration['id'],
          'name': menu_configuration['name'],
          'type': menu_configuration['type'],
          'external': menu_configuration['external'],
          'destinationUrl': menu_configuration['destinationUrl'],
          'menuItemConfigurations': []
        }

        sanitized_menu_item_configurations = []
        menu_configuration['menuItemConfigurations'].each do |menu_item_configuration|
          sanitized_menu_item = {
            'id': menu_item_configuration['id'],
            'name': menu_item_configuration['name'],
            'type': menu_item_configuration['type'],
            'external': menu_item_configuration['external'],
            'destinationUrl': menu_item_configuration['destinationUrl']
          }
          sanitized_menu_item_configurations << sanitized_menu_item
        end
        sanitized_menu_configuration['menuItemConfigurations'] = sanitized_menu_item_configurations
        sanitized_menu_configurations << sanitized_menu_configuration
      end

      site_setting.menu_configurations = sanitized_menu_configurations

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
