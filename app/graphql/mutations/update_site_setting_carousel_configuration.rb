# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingCarouselConfiguration < Mutations::BaseMutation
    argument :site_setting_slug, String, required: true

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :description, String, required: true

    argument :external, Boolean, required: true
    argument :image_url, String, required: true
    argument :target_url, String, required: true

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(site_setting_slug:, slug:, name:, description:, external:, image_url:, target_url:)
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

      carousel_configuration_exists = false
      site_setting.carousel_configurations.each do |carousel_configuration|
        next if carousel_configuration['slug'] != slug

        carousel_configuration_exists = true

        carousel_configuration['name'] = name
        carousel_configuration['description'] = description
        carousel_configuration['external'] = external
        carousel_configuration['image_url'] = image_url
        carousel_configuration['target_url'] = target_url
      end

      unless carousel_configuration_exists
        carousel_configuration = {
          'name': name,
          'slug': slug || reslug_em(name),
          'description': description,
          'external': external,
          'image_url': image_url,
          'target_url': target_url
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
