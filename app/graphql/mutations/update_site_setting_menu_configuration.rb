# frozen_string_literal: true
require 'modules/slugger'

module Mutations
  class UpdateSiteSettingMenuConfiguration < Mutations::BaseMutation
    include Modules::Slugger

    argument :site_setting_slug, String, required: true
    # Parameters for menu (or menu item)
    argument :slug, String, required: false
    argument :name, String, required: true
    argument :type, String, required: true
    # Parameters for menu item only (parent menu don't have these)
    argument :external, Boolean, required: false
    argument :target_url, String, required: false
    # Parent slug is only for menu item
    argument :parent_slug, String, required: false

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(site_setting_slug:, slug:, name:, type:, external:, target_url:, parent_slug:)
      unless an_admin || a_content_editor
        return {
          site_setting: nil,
          errors: ['Must have proper rights to update a site setting object.']
        }
      end

      unless ['menu', 'menu-item'].include?(type)
        return {
          site_setting: nil,
          errors: ['Only correct type is allowed.']
        }
      end

      site_setting = SiteSetting.find_by(slug: site_setting_slug)
      if site_setting.nil?
        return {
          site_setting: nil,
          errors: ['Correct site setting is required.']
        }
      end

      menu_exists = false
      site_setting.menu_configurations.each do |menu_configuration|
        if type == 'menu'
          next unless menu_configuration['slug'] == slug
          # We found the menu, update the menu.
          menu_exists = true
          # Update the slug value if needed.
          updated_slug = reslug_em(name)
          if updated_slug != menu_configuration['slug']
            menu_configuration['slug'] = updated_slug
          end
          # Menu only have name field that can be updated.
          menu_configuration['name'] = name
          break if menu_exists
        elsif type == 'menu-item'
          # Skip until we find the parent menu.
          next unless menu_configuration['slug'] == parent_slug
          # Initialize our menu item search flag.
          menu_item_exists = false
          menu_configuration['menuItemConfigurations'].each do |menu_item|
            # Skip until we find the menu item.
            next unless menu_item['slug'] == slug
            # We found the menu item, update the menu item.
            menu_item_exists = true
            # Update the slug value if needed.
            updated_slug = reslug_em(name)
            if updated_slug != menu_item['slug']
              menu_item['slug'] = updated_slug
            end
            # Update other parts of the menu item.
            menu_item['name'] = name
            menu_item['type'] = type
            menu_item['external'] = external
            menu_item['targetUrl'] = target_url
          end
          # We found the menu and updated the menu, break from the loop.
          break if menu_item_exists
          # We didn't find the menu item, add it.
          menu_item = {
            'name': name,
            'type': type,
            'slug': reslug_em(name),
            'external': external,
            'targetUrl': target_url
          }
          menu_configuration['menuItemConfigurations'] << menu_item
        end
      end

      if type == 'menu' && !menu_exists
        site_setting.menu_configurations << {
          'name': name,
          'type': type,
          'slug': reslug_em(name),
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
