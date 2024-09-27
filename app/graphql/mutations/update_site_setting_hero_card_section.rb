# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingHeroCardSection < Mutations::BaseMutation
    argument :site_setting_slug, String, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :hero_card_configurations, GraphQL::Types::JSON, required: true, default_value: []

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(site_setting_slug:, title: nil, description: nil, hero_card_configurations:)
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

      sanitized_hero_card_configurations = []
      hero_card_configurations.each do |hero_card_configuration|
        sanitized_hero_card_configuration = {
          'id': hero_card_configuration['id'],
          'type': hero_card_configuration['type'],
          'name': hero_card_configuration['name'],
          'title': hero_card_configuration['title'],
          'external': hero_card_configuration['external'],
          'imageUrl': hero_card_configuration['imageUrl'],
          'description': hero_card_configuration['description'],
          'destinationUrl': hero_card_configuration['destinationUrl']
        }
        sanitized_hero_card_configurations << sanitized_hero_card_configuration
      end

      site_setting.hero_card_section['heroCardConfigurations'] = sanitized_hero_card_configurations
      site_setting.hero_card_section['title'] = title unless title.nil?
      site_setting.hero_card_section['description'] = description unless description.nil?

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
