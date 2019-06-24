Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }
  resources :auth_tokens, only: [:show, :new, :create]
  resources :secrets, only: [:show, :new, :create, :edit, :update]
  resources :decrypted_secrets, only: :create

  post '/decrypt_secret', to: 'decrypted_secrets#create'

  get Rails.application.config.topsekrit_google_oauth_callback_path, to: 'oauth_callbacks#google'

  get '/auth/failure', to: 'oauth_callbacks#auth_failure'

  get '/auth/new', to: 'auth_tokens#new'
  root 'pages#home'

  get '/copyright',            to: 'pages#copyright'
  get '/privacy_policy',       to: 'pages#privacy_policy'
  get '/terms_and_conditions', to: 'pages#terms_and_conditions'

  get 'dashboard' , to: 'dashboard#show'
end
