# frozen_string_literal: true

module Types
  class SiteSettingType < BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :description, String, null: true

    field :default_setting, Boolean, null: false
    field :enable_marketplace, Boolean, null: false

    field :favicon_url, String, null: false
    field :exchange_logo_url, String, null: false
    field :open_graph_logo_url, String, null: false

    field :carousel_configurations, GraphQL::Types::JSON, null: false
    field :hero_card_section, GraphQL::Types::JSON, null: false
    field :menu_configurations, GraphQL::Types::JSON, null: false
  end
end
