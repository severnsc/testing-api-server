Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users
      resources :sessions, only: [:create, :destroy]
      resources :account_activations, only:[:edit]
    end
  end

  resources :users
end
