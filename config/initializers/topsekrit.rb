Rails.application.config.before_initialize do
  # If you want to limit the amount of time a secret can be stored, set the time
  # limit here. e.g. if you set 7.days, any secrets older than 7 days cannot be
  # accessed and will be deleted.
  # Set to nil or comment the line if you don't want to enforce this restriction
  Rails.configuration.topsekrit_maximum_expiry_time = 7.days.to_i

  # These settings define who can use the website to send and receive secrets.
  # The options for topsekrit_authorisation_setting are:
  # [:open, :closed, :limited]
  # :open - anyone can use the website to send or receive secrets, ignores the
  #         topsekrit_authorised_domain setting, yolo.
  # :closed - only emails from the topsekrit_authorised_domain domain can send and receive secrets,
  #           use this if you only want to use TopSekr.it internally
  # :limited - emails from the topsekrit_authorised_domain domain can send secrets to anyone and can
  #            receive secrets from anyone, but emails from other domains can't send/receive secrets
  #            to/from each other
  Rails.configuration.topsekrit_authorisation_setting = ENV['TOPSEKRIT_AUTHORISATION_SETTING'].to_s.to_sym
  Rails.configuration.topsekrit_authorised_domain = ENV['TOPSEKRIT_AUTHORISED_DOMAIN']

  # Path for the google oauth2 callback URL, this is what is set with google
  # when you are setting up the client key for the application
  Rails.configuration.topsekrit_google_oauth_callback_path = ENV['GOOGLE_OAUTH_CALLBACK_PATH']

  # Google client ID for this application, get yours from google by following the
  # write up at https://github.com/zquestz/omniauth-google-oauth2#google-api-setup
  Rails.configuration.topsekrit_google_oauth_client_id = ENV['GOOGLE_OAUTH_CLIENT_ID']

  # Google client secret for this application, get yours from google by following the
  # write up at https://github.com/zquestz/omniauth-google-oauth2#google-api-setup
  Rails.configuration.topsekrit_google_oauth_client_secret = ENV['GOOGLE_OAUTH_CLIENT_SECRET']

  # Base URL for the running site. For the production site at https://topsekr.it/ the
  # Base URL would be: https://topsekr.it/, for development this might be http://lvh.me:3000/
  Rails.configuration.topsekrit_base_url = ENV['BASE_URL']
end
