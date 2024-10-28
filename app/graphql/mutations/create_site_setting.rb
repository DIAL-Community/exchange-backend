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

    field :site_setting, Types::SiteSettingType, null: true
    field :errors, [String], null: true

    def resolve(slug:, name:, description:, favicon_url:, exchange_logo_url:, open_graph_logo_url:,
      enable_marketplace:, default_setting:)
      site_setting = SiteSetting.find_by(slug:)
      site_setting_policy = Pundit.policy(context[:current_user], site_setting || SiteSetting.new)

      if site_setting.nil? && !site_setting_policy.create_allowed?
        return {
          site_setting: nil,
          errors: ['Creating / editing site setting is not allowed.']
        }
      end

      if !site_setting.nil? && !site_setting_policy.edit_allowed?
        return {
          site_setting: nil,
          errors: ['Creating / editing site setting is not allowed.']
        }
      end

      unless an_admin
        return {
          site_setting: nil,
          errors: ['Creating / editing site setting is not allowed.']
        }
      end

      if site_setting.nil?
        site_setting = SiteSetting.new(name:, slug: reslug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = SiteSetting.slug_simple_starts_with(site_setting.slug)
                                     .order(slug: :desc)
                                     .first
        unless first_duplicate.nil?
          site_setting.slug += generate_offset(first_duplicate)
        end
      end

      site_setting.name = name
      site_setting.description = description

      site_setting.favicon_url = favicon_url
      site_setting.exchange_logo_url = exchange_logo_url
      site_setting.open_graph_logo_url = open_graph_logo_url

      site_setting.enable_marketplace = enable_marketplace

      if site_setting.new_record?
        site_setting.menu_configurations = []
        site_setting.hero_card_section = {
          'title': 'ui.tool.getStarted',
          'description': 'ui.tool.tagLine',
          'heroCardConfigurations': []
        }
        site_setting.carousel_configurations = []
      end

      successful_operation = false
      ActiveRecord::Base.transaction do
        current_default_setting = SiteSetting.find_by(default_setting: true)
        if default_setting.to_s == 'true' && current_default_setting&.slug != site_setting.slug
          # Only one default setting can exist at a time.
          current_default_setting&.update(default_setting: false)
          # Set the current one as the default setting.
          site_setting.default_setting = true
        end
        site_setting.save
        successful_operation = true
      end

      if successful_operation
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
