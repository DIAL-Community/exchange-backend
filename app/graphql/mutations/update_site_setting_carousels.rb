# frozen_string_literal: true

module Mutations
  class UpdateSiteSettingCarousels < Mutations::BaseMutation
    argument :slug, String, required: true
    argument :carousel_configurations, GraphQL::Types::JSON, required: true, default_value: []

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(slug:, carousel_configurations:)
      puts "Receiving slug: #{slug}."
      puts "Receiving menu configurations: #{carousel_configurations}."

      unless an_admin || a_content_editor
        return {
          site_setting: nil,
          errors: ['Must have proper rights to update a site setting object.']
        }
      end

      if resource.save
        # Successful creation, return the created object with no errors
        {
          site_setting:,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          site_setting: nil,
          errors: resource.errors.full_messages
        }
      end
    end
  end
end
