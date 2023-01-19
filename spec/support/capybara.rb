require 'capybara/rails'
require 'capybara/rspec'
require "selenium/webdriver"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.args << '--headless'
    opts.args << '--disable-site-isolation-trials'
    opts.args << '--no-sandbox'
  end

  options.add_preference(:download, prompt_for_download: false, default_directory: Rails.root.join('tmp/capybara/downloads'))
  options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })

  service_options = ::Selenium::WebDriver::Service.chrome(
    args: {
      port: 9515,
      read_timeout: 120
    }
  )

  remote_caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    'goog:loggingPrefs': {
      browser: ENV['JS_LOG'].to_s == 'true' ? 'ALL' : nil
    }.compact
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    capabilities: [remote_caps, options],
    service: service_options,
    timeout: 120
end

Capybara.javascript_driver = :headless_chrome
Capybara.default_max_wait_time = 15
