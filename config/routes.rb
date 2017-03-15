Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users
      resources :sessions, only: [:create, :destroy]
    end
  end

  resources :users
end
