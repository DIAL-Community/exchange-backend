# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingCarouselConfiguration < Mutations::BaseMutation
    argument :site_setting_slug, String, required: true

    argument :id, String, required: true
    argument :type, String, required: true
    argument :name, String, required: true
    argument :title, String, required: true

    argument :external, Boolean, required: true
    argument :image_url, String, required: true
    argument :description, String, required: true
    argument :destination_url, String, required: true
    argument :callout_title, String, required: true
    argument :style, String, required: true

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(
      site_setting_slug:, id:, type:, name:, title:, description:, external:, image_url:,
      destination_url:, callout_title:, style:
    )
      unless an_admin
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

      carousel_configuration_exists = false
      site_setting.carousel_configurations.each do |carousel_configuration|
        next if carousel_configuration['id'] != id

        carousel_configuration_exists = true

        carousel_configuration['type'] = type
        carousel_configuration['name'] = name
        carousel_configuration['title'] = title
        carousel_configuration['external'] = external
        carousel_configuration['imageUrl'] = image_url
        carousel_configuration['description'] = description
        carousel_configuration['destinationUrl'] = destination_url
        carousel_configuration['calloutTitle'] = callout_title
        carousel_configuration['style'] = style
      end

      unless carousel_configuration_exists
        carousel_configuration = {
          'id': id,
          'type': type,
          'name': name,
          'title': title,
          'external': external,
          'imageUrl': image_url,
          'description': description,
          'destinationUrl': destination_url,
          'calloutTitle': callout_title,
          'style': style
        }

        site_setting.carousel_configurations << carousel_configuration
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
