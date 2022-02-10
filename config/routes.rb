Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants_search#show'
      resources :merchants
      get '/merchants/:id/items', to: 'merchant_items#index'
      # resources :merchant_items, only: [:index]

      get '/items/find_all', to: 'items_search#index'
      resources :items
      get 'items/:id/merchant', to: 'merchant_items#show'
    end
  end
end
