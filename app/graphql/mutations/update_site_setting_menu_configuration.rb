# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingMenuConfiguration < Mutations::BaseMutation
    argument :site_setting_slug, String, required: true
    # Parameters for menu (or menu item)
    argument :id, String, required: true
    argument :name, String, required: true
    argument :type, String, required: true
    argument :external, Boolean, required: false
    argument :destination_url, String, required: false
    # Parent id is only for menu item
    argument :parent_id, String, required: false

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(site_setting_slug:, id:, name:, type:, external:, destination_url:, parent_id:)
      site_setting = SiteSetting.find_by(slug: site_setting_slug)
      site_setting_policy = Pundit.policy(context[:current_user], site_setting || SiteSetting.new)
      if site_setting.nil? || !site_setting_policy.edit_allowed?
        return {
          site_setting: nil,
          errors: ['Editing site setting is not allowed.']
        }
      end

      locked_menu_types = ['admin', 'login', 'help', 'language'].map { |type_name| "locked-#{type_name}-menu" }
      valid_menu_types = locked_menu_types + ['menu', 'menu.item', 'separator']
      unless valid_menu_types.include?(type)
        return {
          site_setting: nil,
          errors: ['Only correct type is allowed.']
        }
      end

      menu_exists = false
      site_setting.menu_configurations.each do |menu_configuration|
        if type == 'menu'
          next unless menu_configuration['id'] == id
          # We found the menu, update the menu.
          menu_exists = true
          # Menu only have name field that can be updated.
          menu_configuration['name'] = name
          menu_configuration['type'] = type
          menu_configuration['external'] = external
          menu_configuration['destinationUrl'] = destination_url
          break if menu_exists
        elsif type == 'menu.item' || type == 'separator'
          # Skip until we find the parent menu.
          next unless menu_configuration['id'] == parent_id
          # Initialize our menu item search flag.
          menu_item_exists = false
          menu_configuration['menuItemConfigurations'].each do |menu_item_configuration|
            # Skip until we find the menu item.
            next unless menu_item_configuration['id'] == id
            # We found the menu item, update the menu item.
            menu_item_exists = true
            # Update other parts of the menu item.
            menu_item_configuration['name'] = name
            menu_item_configuration['type'] = type
            menu_item_configuration['external'] = external
            menu_item_configuration['destinationUrl'] = destination_url
          end
          # We found the menu and updated the menu, break from the loop.
          break if menu_item_exists
          # We didn't find the menu item, add it.
          menu_item_configuration = {
            'id': id,
            'name': name,
            'type': type,
            'external': external,
            'destinationUrl': destination_url
          }
          menu_configuration['menuItemConfigurations'] << menu_item_configuration
        end
      end

      if type == 'menu' && !menu_exists
        site_setting.menu_configurations << {
          'id': id,
          'name': name,
          'type': type,
          'external': external,
          'destinationUrl': destination_url,
          'menuItemConfigurations': []
        }
      end

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
