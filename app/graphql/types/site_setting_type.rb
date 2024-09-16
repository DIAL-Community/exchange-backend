# frozen_string_literal: true

module Types
  class CarouselType < BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :image_url, String, null: false
    field :target_url, String, null: false
  end

  class LandingPageType < BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :image_url, String, null: false
    field :target_url, String, null: false
  end

  class MenuItemType < BaseObject
    field :id, ID, null: false
    field :type, String, null: false
    field :slug, String, null: false
    field :name, String, null: false
    field :external, Boolean, null: true
    field :url, String, null: true
  end

  class DropdownMenuType < BaseObject
    field :id, ID, null: false
    field :type, String, null: false
    field :slug, String, null: false
    field :name, String, null: false

    field :menu_items, [Types::MenuItemType], null: false
  end

  class SiteSettingType < BaseObject
    field :id, ID, null: false
    field :favicon_url, String, null: false
    field :exchange_logo_url, String, null: false
    field :open_graph_logo_url, String, null: false

    field :carousels, [Types::CarouselType], null: false
    field :landing_pages, [Types::LandingPageType], null: false

    field :dropdown_menus, [Types::DropdownMenuType], null: false
  end
end
