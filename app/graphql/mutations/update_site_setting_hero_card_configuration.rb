# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingHeroCardConfiguration < Mutations::BaseMutation
    argument :site_setting_slug, String, required: true

    argument :id, String, required: true
    argument :type, String, required: true
    argument :name, String, required: true
    argument :title, String, required: true
    argument :description, String, required: true

    argument :external, Boolean, required: true
    argument :image_url, String, required: true
    argument :destination_url, String, required: true

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(site_setting_slug:, id:, type:, name:, title:, description:, external:, image_url:, destination_url:)
      site_setting = SiteSetting.find_by(slug: site_setting_slug)
      site_setting_policy = Pundit.policy(context[:current_user], site_setting || SiteSetting.new)
      if site_setting.nil? || !site_setting_policy.edit_allowed?
        return {
          site_setting: nil,
          errors: ['Editing site setting is not allowed.']
        }
      end

      hero_card_configuration_exists = false

      hero_card_configurations = site_setting.hero_card_section['heroCardConfigurations']
      hero_card_configurations.each do |hero_card_configuration|
        next if hero_card_configuration['id'] != id

        hero_card_configuration_exists = true

        hero_card_configuration['type'] = type
        hero_card_configuration['name'] = name
        hero_card_configuration['title'] = title
        hero_card_configuration['external'] = external
        hero_card_configuration['imageUrl'] = image_url
        hero_card_configuration['description'] = description
        hero_card_configuration['destinationUrl'] = destination_url
      end

      unless hero_card_configuration_exists
        hero_card_configuration = {
          'id': id,
          'type': type,
          'name': name,
          'title': title,
          'external': external,
          'imageUrl': image_url,
          'description': description,
          'destinationUrl': destination_url
        }
        hero_card_configurations << hero_card_configuration
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
