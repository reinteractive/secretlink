require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Topsekrit
  class Application < Rails::Application

    config.skylight.environments += ['staging']
    config.skylight.alert_log_file = true


    # config.skylight.environments += ['staging']

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.filter_parameters << :secret
    #config.load_defaults 5.0
  end
end
