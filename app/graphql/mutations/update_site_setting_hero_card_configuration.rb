# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingHeroCardConfiguration < Mutations::BaseMutation
    argument :site_setting_slug, String, required: true

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :description, String, required: true

    argument :external, Boolean, required: true
    argument :image_url, String, required: true
    argument :destination_url, String, required: true

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(site_setting_slug:, slug:, name:, description:, external:, image_url:, destination_url:)
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

      hero_card_configuration_exists = false
      site_setting.hero_card_configurations.each do |hero_card_configuration|
        next if hero_card_configuration['slug'] != slug

        hero_card_configuration_exists = true
        hero_card_configuration['name'] = name
        hero_card_configuration['description'] = description
        hero_card_configuration['external'] = external
        hero_card_configuration['image_url'] = image_url
        hero_card_configuration['destination_url'] = destination_url
      end

      unless hero_card_configuration_exists
        hero_card_configuration = {
          'name': name,
          'slug': slug || reslug_em(name),
          'description': description,
          'external': external,
          'image_url': image_url,
          'destination_url': destination_url
        }

        site_setting.hero_card_configurations << hero_card_configuration
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
