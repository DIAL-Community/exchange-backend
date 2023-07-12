# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Registry
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(7.0)

    config.i18n.available_locales = %i[en cs fr de es pt sw]
    config.i18n.default_locale = :en
    config.i18n.locale = config.i18n.default_locale
    config.i18n.load_path += Dir[root.join('config', 'locales', '**', '*.yml')]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.geocode = config_for(:esri)
    config.settings = config_for(:settings)

    config.exceptions_app = routes

    config.active_record.schema_format = :sql

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
