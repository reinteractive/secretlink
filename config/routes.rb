Rails.application.routes.draw do
  resources :auth_tokens, only: [:show, :new, :create]
  resources :secrets, only: [:show, :new, :create]
  get '/:uuid/:secret_key/:auth_token', to: 'secrets#show'
  root 'auth_tokens#new'
end