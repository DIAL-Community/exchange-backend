# frozen_string_literal: true
require 'modules/slugger'

module Mutations
  class UpdateSiteSettingMenuConfigurations < Mutations::BaseMutation
    include Modules::Slugger

    argument :site_setting_slug, String, required: true
    argument :menu_configurations, GraphQL::Types::JSON, required: true

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(site_setting_slug:, menu_configurations:)
      unless an_admin || a_content_editor
        return {
          site_setting: nil,
          errors: ['Must have proper rights to update a site setting object.']
        }
      end

      site_setting = SiteSetting.find_by(slug: site_setting_slug)
      if site_setting.nil?
        return {
          site_setting: nil,
          errors: ['Correct site setting is required.']
        }
      end

      sanitized_menu_configurations = []
      menu_configurations.each do |menu_configuration|
        sanitized_menu_configuration = {
          'name': menu_configuration['name'],
          'type': menu_configuration['type'],
          'slug': reslug_em(menu_configuration['name']),
          'external': menu_configuration['external'],
          'destinationUrl': menu_configuration['destinationUrl'],
          'menuItemConfigurations': []
        }

        sanitized_menu_item_configurations = []
        menu_configuration['menuItemConfigurations'].each do |menu_item_configuration|
          sanitized_menu_item = {
            'name': menu_item_configuration['name'],
            'type': menu_item_configuration['type'],
            'slug': reslug_em(menu_item_configuration['name']),
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
