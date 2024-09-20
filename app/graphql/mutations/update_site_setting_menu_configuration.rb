# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingMenuConfiguration < Mutations::BaseMutation
    argument :site_setting_slug, String, required: true
    # Parameters for menu (or menu item)
    argument :slug, String, required: true
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

      if parent_slug.nil?
        menu_configuration = {
          'name': name,
          'type': type,
          'slug': slug || reslug_em(name)
        }

        if type == 'menu'
          menu_configuration['menuItems'] = []
        else
          menu_configuration['external'] = external
          menu_configuration['targetUrl'] = target_url
        end
        site_setting.menu_configurations << menu_configurations
      else
        site_setting.menu_configurations.each do |menu_configuration|
          next unless menu_configuration['slug'] == parent_slug

          menu_item_exists = false
          menu_configuration['menuItems'].each do |menu_item|
            next unless menu_item['slug'] == slug

            menu_item_exists = true

            menu_item['name'] = name
            menu_item['type'] = type
            menu_item['external'] = external
            menu_item['targetUrl'] = target_url
          end

          next if menu_item_exists
          menu_item = {
            'name': name,
            'type': type,
            'slug': slug || reslug_em(name),
            'external': external,
            'targetUrl': target_url
          }
          menu_configuration['menuItems'] << menu_item
        end
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
