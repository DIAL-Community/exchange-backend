# frozen_string_literal: true

module Types
  class CarouselType < BaseUnion
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :image_url, String, null: false
    field :target_url, String, null: false
  end

  class LandingPageType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :image_url, String, null: false
    field :target_url, String, null: false
  end

  class MenuItemType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :url, String, null: false
    field :menu, Types::MenuType, null: false
  end

  class DropdownMenuType < BaseObject
    field :id, ID, null: false
    field :name, String, null: false

    field :menu_items, [Types::MenuItemType], null: false
  end

  class SiteSettingType < Types::BaseObject
    field :id, ID, null: false
    field :logo_url, String, null: false
    field :favicon_url, String, null: false

    field :carousels, [Types::CarouselType], null: false
    field :landing_pages, [Types::LandingPageType], null: false

    field :dropdown_menus, [Types::DropdownMenuType], null: false
  end
end
