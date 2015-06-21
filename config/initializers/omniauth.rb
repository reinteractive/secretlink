Rails.application.config.after_initialize do
  OmniAuth.config.full_host = Rails.configuration.topsekrit_base_url
end
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.config.topsekrit_google_oauth_client_id,
           Rails.application.config.topsekrit_google_oauth_client_secret
end