Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }

  get '/', to: 'dashboard#index', as: 'admin_root', constraints: lambda { |request|
    request.env['warden'].user.present?
  }

  get '/', to: 'pages#home', as: 'root'

  resources :secrets, only: [:show, :new, :create, :edit, :update]
  resources :decrypted_secrets, only: :create

  post '/decrypt_secret', to: 'decrypted_secrets#create'

  get Rails.application.config.topsekrit_google_oauth_callback_path, to: 'oauth_callbacks#google'

  get '/auth/failure', to: 'oauth_callbacks#auth_failure'

  get '/home',                 to: 'pages#home'
  get '/copyright',            to: 'pages#copyright'
  get '/privacy_policy',       to: 'pages#privacy_policy'
  get '/terms_and_conditions', to: 'pages#terms_and_conditions'

  get 'dashboard' , to: 'dashboard#index'
end
