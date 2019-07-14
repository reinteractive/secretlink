Rails.application.config.after_initialize do
  OmniAuth.config.full_host = Rails.configuration.topsekrit_base_url
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.configuration.topsekrit_google_oauth_client_id,
           Rails.configuration.topsekrit_google_oauth_client_secret,
           {
            redirect_uri: URI::join(Rails.configuration.topsekrit_base_url,
              Rails.configuration.topsekrit_google_oauth_callback_path).to_s
           }
end
