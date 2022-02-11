Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants_search#show'
      get '/merchants/:id/items', to: 'merchant_items#index'
      resources :merchants
      # resources :merchant_items, only: [:index]

      get '/items/find_all', to: 'items_search#index'
      get 'items/:id/merchant', to: 'merchant_items#show'
      resources :items
    end
  end
end
