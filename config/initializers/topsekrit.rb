Rails.application.config.before_initialize do
  # If you want to limit the amount of time a secret can be stored, set the time
  # limit here. e.g. if you set 7.days, any secrets older than 7 days cannot be
  # accessed and will be deleted.
  # Set to nil or comment the line if you don't want to enforce this restriction
  Rails.configuration.topsekrit_maximum_expiry_time = 7.days.to_i

  # Only allow secrets to be created by email addresses from certain domains.
  # e.g. if you set to 'acme.com', only email addresses @acme.com will be able to
  # create secrets, anyone else who requests an auth token will receive an error.
  # Takes a single string: 'acme.com' or an array: ['acme.com', 'acme.org']
  # Set to nil or comment the line if you don't want to enforce this restriction
  Rails.configuration.topsekrit_domains_allowed_to_create_secrets = ENV['TOPSEKRIT_ALLOWED_CREATE']

  # Only allow secrets to be shared with email addresses from certain domains.
  # e.g. if you set to 'acme.com', only email addresses @acme.com will be able to
  # receive secrets, setting the 'To address' setting to another domain will
  # receive an error when creating a secret.
  # Takes a single string: 'acme.com' or an array: ['acme.com', 'acme.org']
  # Set to nil or comment the line if you don't want to enforce this restriction
  Rails.configuration.topsekrit_domains_allowed_to_receive_secrets = ENV['TOPSEKRIT_ALLOWED_RECEIVE']

  # Path for the google oauth2 callback URL, this is what is set with google
  # when you are setting up the client key for the application
  Rails.configuration.topsekrit_google_oauth_callback_path = ENV['GOOGLE_OAUTH_CALLBACK_PATH']

  # Google client ID for this application, get yours from google by following the
  # write up at https://github.com/zquestz/omniauth-google-oauth2#google-api-setup
  Rails.configuration.topsekrit_google_oauth_client_id = ENV['GOOGLE_OAUTH_CLIENT_ID']

  # Google client secret for this application, get yours from google by following the
  # write up at https://github.com/zquestz/omniauth-google-oauth2#google-api-setup
  Rails.configuration.topsekrit_google_oauth_client_secret = ENV['GOOGLE_OAUTH_CLIENT_SECRET']

  Rails.configuration.topsekrit_base_url = ENV['BASE_URL']
end