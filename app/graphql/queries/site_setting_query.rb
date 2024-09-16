# frozen_string_literal: true

module Queries
  class SiteSettingQuery < Queries::BaseQuery
    type Types::SiteSettingType, null: true

    def resolve
      carousels = [{
        id: 1,
        slug: 'dynamic-carousel-1',
        name: 'Dynamic Carousel 1',
        description: 'Example of dynamic carousel created on the backend.',
        image_url: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
        target_url: 'https://www.google.com'
      }]

      landing_pages = [{
        id: 1,
        slug: 'dynamic-landing-page-1',
        name: 'Dynamic Landing Page 1',
        description: 'landing page 1',
        image_url: 'https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png',
        target_url: 'https://www.google.com'
      }]

      dropdown_menus = [{
        id: 1,
        type: 'menu',
        slug: 'dynamic-menu',
        name: 'Dynamic Menu',
        menu_items: [{
          id: 1,
          type: 'menu-item',
          slug: 'products-dynamic-menu',
          name: 'Products (Dynamic Menu)',
          external: false,
          url: '/products'
        }, {
          id: 2,
          type: 'menu-item',
          slug: 'google-external',
          name: 'Google (External)',
          external: true,
          url: 'https://www.google.com'
        }, {
          id: 3,
          type: 'separator',
          slug: 'separator-one',
          name: 'Separator One'
        }, {
          id: 4,
          type: 'menu-item',
          slug: 'organization-dynamic-menu',
          name: 'Organizations (Dynamic Menu)',
          external: false,
          url: '/organizations'
        }]
      }]

      {
        id: 1,
        favicon_url: 'https://exchange.dial.global/favicon.ico',
        exchange_logo_url: 'https://exchange-dev.dial.global/ui/v1/exchange-logo.svg',
        open_graph_logo_url: 'https://exchange.dial.global/images/hero-image/exchange-hero.png',
        carousels:,
        landing_pages:,
        dropdown_menus:
      }
    end
  end
end
