Rails.application.routes.draw do
  resources :auth_tokens, only: [:show, :new, :create]
  resources :secrets, only: [:show, :new, :create]
  resources :decrypted_secrets, only: :create
  post '/decrypt_secret', to: 'decrypted_secrets#create'
  get Rails.application.config.topsekrit_google_oauth_callback_path, to: 'oauth_callbacks#google'
  get '/auth/failure', to: 'oauth_callbacks#auth_failure'
  get '/:uuid/:secret_key/:auth_token', to: 'secrets#show'
  get '/auth/new', to: 'auth_tokens#new'
  root 'auth_tokens#new'

  get '/copyright',            to: 'pages#copyright'
  get '/privacy_policy',       to: 'pages#privacy_policy'
  get '/terms_and_conditions', to: 'pages#terms_and_conditions'
end