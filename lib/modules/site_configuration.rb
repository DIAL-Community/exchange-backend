# frozen_string_literal: true

module Modules
  module SiteConfiguration
    def create_default_site_configuration
      default_site_setting = SiteSetting.find_by(slug: 'default-site-settings')
      if default_site_setting.nil?
        default_site_setting = SiteSetting.new(slug: 'default-site-settings')
      end

      default_site_setting.name = 'Default Site Settings'
      default_site_setting.description = 'Default settings for the exchange site.'

      default_site_setting.favicon_url = '/favicon.ico'
      default_site_setting.exchange_logo_url = '/ui/v1/hero-dx-bg.svg'
      default_site_setting.open_graph_logo_url = '/ui/v1/hero-dx-bg.svg'

      default_site_setting.enable_marketplace = true
      default_site_setting.default_setting = true

      default_menu_configurations = [{
        id: SecureRandom.uuid,
        name: 'ui.marketplace.label',
        type: 'menu',
        external: false,
        destinationUrl: nil,
        menuItemConfigurations: [{
          id: SecureRandom.uuid,
          name: 'ui.opportunity.header',
          type: 'menu.item',
          external: false,
          destinationUrl: '/opportunities'
        }, {
          id: SecureRandom.uuid,
          name: 'ui.storefront.header',
          type: 'menu.item',
          external: false,
          destinationUrl: '/storefronts'
        }]
      }, {
        id: SecureRandom.uuid,
        name: 'header.catalog',
        type: 'menu',
        external: false,
        destinationUrl: nil,
        menuItemConfigurations: [{
          id: SecureRandom.uuid,
          name: 'header.catalog',
          type: 'separator',
          external: false,
          destinationUrl: nil
        }, {
          id: SecureRandom.uuid,
          name: 'filter.entity.useCases',
          type: 'menu.item',
          external: false,
          destinationUrl: '/use-cases'
        }, {
          id: SecureRandom.uuid,
          name: 'filter.entity.buildingBlocks',
          type: 'menu.item',
          external: false,
          destinationUrl: '/building-blocks'
        }, {
          id: SecureRandom.uuid,
          name: 'filter.entity.products',
          type: 'menu.item',
          external: false,
          destinationUrl: '/products'
        }, {
          id: SecureRandom.uuid,
          name: 'header.supportingTools',
          type: 'separator',
          external: false,
          destinationUrl: nil
        }, {
          id: SecureRandom.uuid,
          name: 'filter.entity.maps',
          type: 'menu.item',
          external: false,
          destinationUrl: '/maps'
        }, {
          id: SecureRandom.uuid,
          name: 'filter.entity.datasets',
          type: 'menu.item',
          external: false,
          destinationUrl: '/datasets'
        }, {
          id: SecureRandom.uuid,
          name: 'filter.entity.organizations',
          type: 'menu.item',
          external: false,
          destinationUrl: '/organizations'
        }, {
          id: SecureRandom.uuid,
          name: 'filter.entity.projects',
          type: 'menu.item',
          external: false,
          destinationUrl: '/projects'
        }, {
          id: SecureRandom.uuid,
          name: 'filter.entity.sdgs',
          type: 'menu.item',
          external: false,
          destinationUrl: '/sdgs'
        }, {
          id: SecureRandom.uuid,
          name: 'filter.entity.workflows',
          type: 'menu.item',
          external: false,
          destinationUrl: '/workflows'
        }]
      }, {
        id: SecureRandom.uuid,
        name: 'header.resources',
        type: 'menu',
        external: false,
        destinationUrl: nil,
        menuItemConfigurations: [{
          id: SecureRandom.uuid,
          name: 'header.playbooks',
          type: 'menu.item',
          external: false,
          destinationUrl: '/playbooks'
        }, {
          id: SecureRandom.uuid,
          name: 'header.wizard',
          type: 'menu.item',
          external: false,
          destinationUrl: '/wizard'
        }, {
          id: SecureRandom.uuid,
          name: 'header.insights',
          type: 'menu.item',
          external: false,
          destinationUrl: '/resources'
        }, {
          id: SecureRandom.uuid,
          name: 'header.govstack',
          type: 'menu.item',
          external: false,
          destinationUrl: '/govstack'
        }]
      }, {
        id: SecureRandom.uuid,
        name: 'ui.siteSetting.menu.adminMenu',
        type: 'locked.admin.menu',
        menuItemConfigurations: []
      }, {
        id: SecureRandom.uuid,
        name: 'ui.siteSetting.menu.loginMenu',
        type: 'locked.login.menu',
        menuItemConfigurations: []
      }, {
        id: SecureRandom.uuid,
        name: 'ui.siteSetting.menu.helpMenu',
        type: 'locked.help.menu',
        menuItemConfigurations: []
      }, {
        id: SecureRandom.uuid,
        name: 'ui.siteSetting.menu.languageMenu',
        type: 'locked.language.menu',
        menuItemConfigurations: []
      }]
      default_site_setting.menu_configurations = default_menu_configurations

      default_hero_card_section = {
        id: SecureRandom.uuid,
        title: 'ui.tool.getStarted',
        description: 'ui.tool.tagLine',
        heroCardConfigurations: [{
          id: SecureRandom.uuid,
          type: 'default.useCase.heroCard',
          name: 'Use Case Card',
          title: 'ui.product.header',
          description: 'useCase.hint.subtitle',
          imageUrl: '/ui/v1/use-case-header.svg',
          external: false,
          destinationUrl: '/use-cases'
        }, {
          id: SecureRandom.uuid,
          type: 'default.buildingBlock.heroCard',
          name: 'Building Block Hero Card',
          title: 'ui.buildingBlock.header',
          description: 'buildingBlock.hint.subtitle',
          imageUrl: '/ui/v1/building-block-header.svg',
          external: false,
          destinationUrl: '/building-blocks'
        }, {
          id: SecureRandom.uuid,
          type: 'default.product.heroCard',
          name: 'Product Hero Card',
          title: 'ui.product.header',
          description: 'product.hint.subtitle',
          imageUrl: '/ui/v1/product-header.svg',
          external: false,
          destinationUrl: '/products'
        }]
      }
      default_site_setting.hero_card_section = default_hero_card_section

      default_carousel_configurations = [{
        id: SecureRandom.uuid,
        type: 'default.exchange.carousel',
        name: 'Exchange Carousel',
        title: 'ui.hero.exchange.title',
        imageUrl: nil,
        external: false,
        description: 'ui.hero.exchange.tagLine',
        calloutTitle: nil,
        destinationUrl: nil,
        style: nil
      }, {
        id: SecureRandom.uuid,
        type: 'default.marketplace.carousel',
        name: 'Marketplace Carousel',
        title: 'ui.marketplace.label',
        imageUrl: nil,
        external: false,
        description: 'ui.marketplace.description',
        calloutTitle: 'ui.marketplace.browse',
        destinationUrl: '/opportunities',
        style: nil
      }]
      default_site_setting.carousel_configurations = default_carousel_configurations

      if default_site_setting.save
        puts 'Default site setting configuration has been regenerated.'
      end
    end
  end
end