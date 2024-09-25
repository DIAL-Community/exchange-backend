# frozen_string_literal: true

require 'modules/slugger'

include Modules::Slugger

namespace :configuration do
  desc 'Regenerate default site configurations.'
  task regenerate_default_site_configuration: :environment do
    default_site_setting = SiteSetting.find_by(slug: 'default-site-setting')
    if default_site_setting.nil?
      default_site_setting = SiteSetting.new(slug: 'default-site-setting')
    end

    default_site_setting.name = 'Default Site Setting'
    default_site_setting.description = 'Default configuration for the exchange site.'

    default_site_setting.favicon_url = '/favicon.ico'
    default_site_setting.exchange_logo_url = '/ui/v1/hero-dx-bg.svg'
    default_site_setting.open_graph_logo_url = '/ui/v1/hero-dx-bg.svg'

    default_site_setting.enable_marketplace = true
    default_site_setting.default_setting = true

    default_menu_configurations = [{
      id: SecureRandom.uuid,
      name: 'Marketplace',
      type: 'menu',
      external: false,
      destinationUrl: nil,
      menuItemConfigurations: [{
        id: SecureRandom.uuid,
        name: 'RFP Radar',
        type: 'menu-item',
        external: false,
        destinationUrl: '/opportunities'
      }, {
        id: SecureRandom.uuid,
        name: 'Storefronts',
        type: 'menu-item',
        external: false,
        destinationUrl: '/storefronts'
      }]
    }, {
      id: SecureRandom.uuid,
      name: 'Catalog',
      type: 'menu',
      external: false,
      destinationUrl: nil,
      menuItemConfigurations: [{
        id: SecureRandom.uuid,
        name: 'Catalog',
        type: 'separator',
        external: false,
        destinationUrl: nil
      }, {
        id: SecureRandom.uuid,
        name: 'Use Case',
        type: 'menu-item',
        external: false,
        destinationUrl: '/use-cases'
      }, {
        id: SecureRandom.uuid,
        name: 'Building Blocks',
        type: 'menu-item',
        external: false,
        destinationUrl: '/building-blocks'
      }, {
        id: SecureRandom.uuid,
        name: 'Products',
        type: 'menu-item',
        external: false,
        destinationUrl: '/products'
      }, {
        id: SecureRandom.uuid,
        name: 'Supporting Tools',
        type: 'separator',
        external: false,
        destinationUrl: nil
      }, {
        id: SecureRandom.uuid,
        name: 'Maps',
        type: 'menu-item',
        external: false,
        destinationUrl: '/maps'
      }, {
        id: SecureRandom.uuid,
        name: 'Open Data',
        type: 'menu-item',
        external: false,
        destinationUrl: '/datasets'
      }, {
        id: SecureRandom.uuid,
        name: 'Organizations',
        type: 'menu-item',
        external: false,
        destinationUrl: '/organizations'
      }, {
        id: SecureRandom.uuid,
        name: 'Projects',
        type: 'menu-item',
        external: false,
        destinationUrl: '/projects'
      }, {
        id: SecureRandom.uuid,
        name: 'SDGs',
        type: 'menu-item',
        external: false,
        destinationUrl: '/sdgs'
      }, {
        id: SecureRandom.uuid,
        name: 'Workflows',
        type: 'menu-item',
        external: false,
        destinationUrl: '/workflows'
      }]
    }, {
      id: SecureRandom.uuid,
      name: 'Resources',
      type: 'menu',
      external: false,
      destinationUrl: nil,
      menuItemConfigurations: [{
        id: SecureRandom.uuid,
        name: 'Playbooks',
        type: 'menu-item',
        external: false,
        destinationUrl: '/playbooks'
      }, {
        id: SecureRandom.uuid,
        name: 'Recommendation Wizard',
        type: 'menu-item',
        external: false,
        destinationUrl: '/wizard'
      }, {
        id: SecureRandom.uuid,
        name: 'Resource Hub',
        type: 'menu-item',
        external: false,
        destinationUrl: '/resources'
      }, {
        id: SecureRandom.uuid,
        name: 'Govstack Portal',
        type: 'menu-item',
        external: false,
        destinationUrl: '/govstack'
      }]
    }, {
      id: SecureRandom.uuid,
      name: 'User Menu',
      type: 'locked-user-menu',
      menuItemConfigurations: []
    }, {
      id: SecureRandom.uuid,
      name: 'Help Menu',
      type: 'locked-help-menu',
      menuItemConfigurations: []
    }, {
      id: SecureRandom.uuid,
      name: 'Language Menu',
      type: 'locked-language-menu',
      menuItemConfigurations: []
    }]
    default_site_setting.menu_configurations = default_menu_configurations

    default_hero_card_configurations = [{
      id: SecureRandom.uuid,
      name: 'Hero Card 1',
      type: 'hero-card',
      title: 'Hero Card 1',
      description: 'Hero Card 1',
      imageUrl: '/ui/v1/hero-dx-bg.svg'
    }]
    default_site_setting.hero_card_configurations = default_hero_card_configurations

    default_carousel_configurations = [{
      id: SecureRandom.uuid,
      name: 'Carousel 1',
      type: 'carousel',
      title: 'Carousel 1',
      description: 'Carousel 1',
      imageUrl: '/ui/v1/hero-dx-bg'
    }]
    default_site_setting.carousel_configurations = default_carousel_configurations

    if default_site_setting.save
      puts 'Default site setting configuration has been regenerated.'
    end
  end
end
