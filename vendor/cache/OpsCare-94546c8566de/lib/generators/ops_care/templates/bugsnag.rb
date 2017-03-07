if Rails.env.production? || Rails.env.staging?
  Bugsnag.configure do |config|
    config.api_key = ENV['BUGSNAG_KEY']
  end
end
