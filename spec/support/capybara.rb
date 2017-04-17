require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.default_max_wait_time = 15

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, debug: false)
end
Capybara.register_driver :poltergeist_ignore_js_errors do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end
Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: 'open', js_errors: false)
end

# Choose your poison
driver = :poltergeist
# driver = :poltergeist_debug
# driver = :poltergeist_ignore_js_errors

Capybara.javascript_driver = driver
