if Rails.env.production? || Rails.env.staging?
  Bugsnag.configure do |config|
    config.api_key = ENV['BUGSNAG_KEY']
    config.notify_release_stages = ['production','staging']
    config.release_stage = ENV['BUGSNAG_ENV'] || ENV['RAILS_ENV']
  end
end
