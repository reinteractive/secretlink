Rails.application.config.after_initialize do
  OmniAuth.config.full_host = Rails.configuration.topsekrit_base_url
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.configuration.topsekrit_google_oauth_client_id,
           Rails.configuration.topsekrit_google_oauth_client_secret
end

OmniAuth.config.allowed_request_methods = %i[get]


