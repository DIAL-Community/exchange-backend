# frozen_string_literal: true

module Queries
  class SiteSettingQuery < Queries::BaseQuery
    type Types::SectorType, null: true

    def resolve
      carousels = [{
        id: 1,
        name: 'carousel 1',
        description: 'carousel 1',
        image_url: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
        target_url: 'https://www.google.com'
      }]

      landing_pages = [{
        id: 1,
        name: 'landing page 1',
        description: 'landing page 1',
        image_url: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
        target_url: 'https://www.google.com'
      }]

      dropdown_menus = [{
        id: 1,
        name: 'menu 1',
        menu_items: [{
          id: 1,
          name: 'menu item 1',
          url: 'https://www.google.com'
        }, {
          id: 2,
          name: 'menu item 2',
          url: 'https://www.google.com'
        }, {
          id: 3,
          name: 'menu item 3',
          url: 'https://www.google.com'
        }]
      }]

      {
        id: 1,
        favicon_url: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
        tenant_logo_url: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
        carousels:,
        landing_pages:,
        dropdown_menus:
      }
    end
  end
end
