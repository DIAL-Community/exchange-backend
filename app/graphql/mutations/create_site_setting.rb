# frozen_string_literal: true
require 'modules/slugger'

module Mutations
  class CreateSiteSetting < Mutations::BaseMutation
    include Modules::Slugger

    argument :slug, String, required: true
    argument :name, String, required: true
    argument :description, String, required: true

    argument :favicon_url, String, required: true
    argument :exchange_logo_url, String, required: true
    argument :open_graph_logo_url, String, required: true

    argument :enable_marketplace, Boolean, required: true
    argument :default_setting, Boolean, required: true

    argument :carousel_configurations, GraphQL::Types::JSON, required: false, default_value: []
    argument :hero_card_configurations, GraphQL::Types::JSON, required: false, default_value: []
    argument :menu_configurations, GraphQL::Types::JSON, required: false, default_value: []

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(
      slug:, name:, description:, favicon_url:, exchange_logo_url:, open_graph_logo_url:,
      enable_marketplace:, default_setting:,
      carousel_configurations:, hero_card_configurations:, menu_configurations:
    )
      unless an_admin || a_content_editor
        return {
          site_setting: nil,
          errors: ['Must have proper rights to update a site setting object.']
        }
      end

      site_setting = SiteSetting.find_by(slug:)
      if site_setting.nil?
        site_setting = SiteSetting.new(name:, slug: reslug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = SiteSetting.slug_simple_starts_with(site_setting.slug)
                                     .order(slug: :desc)
                                     .first
        unless first_duplicate.nil?
          site_setting.slug = site_setting.slug + generate_offset(first_duplicate)
        end
      end

      site_setting.name = name
      site_setting.description = description

      site_setting.favicon_url = favicon_url
      site_setting.exchange_logo_url = exchange_logo_url
      site_setting.open_graph_logo_url = open_graph_logo_url

      site_setting.enable_marketplace = enable_marketplace
      site_setting.default_setting = default_setting

      site_setting.carousel_configurations = carousel_configurations
      site_setting.hero_card_configurations = hero_card_configurations
      site_setting.menu_configurations = menu_configurations

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
          errors: resource.errors.full_messages
        }
      end
    end
  end
end
