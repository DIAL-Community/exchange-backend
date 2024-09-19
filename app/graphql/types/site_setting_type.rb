# frozen_string_literal: true

module Types
  class CarouselType < BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :image_url, String, null: false
    field :target_url, String, null: false
    field :external, Boolean, null: true
  end

  class HeroCardType < BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :image_url, String, null: false
    field :target_url, String, null: false
    field :external, Boolean, null: true
  end

  class MenuItemType < BaseObject
    field :id, ID, null: false
    field :type, String, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :target_url, String, null: true
    field :external, Boolean, null: true
  end

  class MenuType < BaseObject
    field :id, ID, null: false
    field :type, String, null: false
    field :slug, String, null: false
    field :name, String, null: false

    field :menu_items, [Types::MenuItemType], null: false
  end

  class SiteSettingType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: true

    field :favicon_url, String, null: false
    field :exchange_logo_url, String, null: false
    field :open_graph_logo_url, String, null: false

    field :carousels, [Types::CarouselType], null: false
    field :hero_cards, [Types::HeroCardType], null: false

    field :menus, [Types::MenuType], null: false
  end
end
