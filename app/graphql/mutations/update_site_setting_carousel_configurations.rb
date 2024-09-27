# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingCarouselConfigurations < Mutations::BaseMutation
    argument :site_setting_slug, String, required: true
    argument :carousel_configurations, GraphQL::Types::JSON, required: true, default_value: []

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(site_setting_slug:, carousel_configurations:)
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

      sanitized_carousel_configurations = []
      carousel_configurations.each do |carousel_configuration|
        sanitized_carousel_configuration = {
          'id': carousel_configuration['id'],
          'type': carousel_configuration['type'],
          'name': carousel_configuration['name'],
          'title': carousel_configuration['title'],
          'external': carousel_configuration['external'],
          'imageUrl': carousel_configuration['imageUrl'],
          'description': carousel_configuration['description'],
          'destinationUrl': carousel_configuration['destinationUrl'],
          'calloutTitle': carousel_configuration['calloutTitle'],
          'style': carousel_configuration['style']
        }
        sanitized_carousel_configurations << sanitized_carousel_configuration
      end

      site_setting.carousel_configurations = sanitized_carousel_configurations

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
