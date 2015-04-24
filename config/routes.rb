Rails.application.routes.draw do
  resources :auth_tokens, only: [:show, :new, :create]
  resources :secrets, only: [:show, :new, :create]
  resources :decrypted_secrets, only: :create
  post '/decrypt_secret', to: 'decrypted_secrets#create'
  get '/auth/google_oauth2/callback', to: 'oauth_callbacks#google'
  get '/auth/failure', to: 'oauth_callbacks#auth_failure'
  get '/:uuid/:secret_key/:auth_token', to: 'secrets#show'
  root 'auth_tokens#new'
end