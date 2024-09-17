# frozen_string_literal: true

module Queries
  class SiteSettingQuery < Queries::BaseQuery
    type Types::SiteSettingType, null: true

    def resolve
      carousels = [{
        id: 1,
        slug: 'dynamic-carousel-1',
        name: 'Resource Hub (Dynamic Carousel)',
        description: "
          Nunc malesuada aliquet auctor. Duis vulputate ante sem, non luctus augue lobortis at. In bibendum ullamcorper.
        ",
        image_url: 'https://resource.dial.global/images/hero-image/hub-cover.svg',
        target_url: 'https://resource.dial.global',
        external: true
      }, {
        id: 2,
        slug: 'internal-resource-page',
        name: 'Exchange Resource (Dynamic Carousel)',
        description: "
          Etiam id purus id tortor suscipit scelerisque. Etiam ex purus, pellentesque vitae dui sed, mollis mollis.
        ",
        image_url: 'https://resource.dial.global/images/hero-image/hub-hero.svg',
        target_url: '/resources',
        external: false
      }]

      landing_pages = [{
        id: 2,
        slug: 'resource-dynamic-landing-card',
        name: 'Resource (Dynamic Landing Card)',
        description: "
          Ut laoreet hendrerit tellus, in blandit est maximus quis. Sed tempus, lorem ut placerat blandit,
          odio orci tempus lectus, id facilisis massa turpis at lacus. Proin semper nunc odio, eget malesuada
          sapien viverra vel. Vestibulum eu nulla id elit lacinia.
        ",
        image_url: 'https://resource.dial.global/ui/v1/resource-header.svg',
        target_url: '/resources',
        external: false
      }, {
        id: 1,
        slug: 'google-external-dynamic',
        name: 'Google (External Dynamic)',
        description: "
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis a sollicitudin nunc.
          Sed non mollis tortor. Curabitur metus enim, tincidunt et facilisis quis, ultrices a tellus.
          Cras hendrerit, justo viverra pellentesque laoreet, odio sem porta nunc, at finibus ante purus.
        ",
        image_url:
          'https://lh3.googleusercontent.com/' \
          'COxitqgJr1sJnIDe8-jiKhxDx1FrYbtRHKJ9z_hELisAlapwE9LUPh6fcXIfb5vwpbMl4xl9H9TRFPc5NOO8Sb3VSgIBrfRYvW6cUA',
        target_url: 'https://www.google.com',
        external: true
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
          target_url: '/products',
          external: false
        }, {
          id: 2,
          type: 'menu-item',
          slug: 'google-external',
          name: 'Google (External)',
          target_url: 'https://www.google.com',
          external: true
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
          target_url: '/organizations',
          external: false
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
