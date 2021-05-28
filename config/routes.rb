Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      #merchants
      resources :merchants, only: [:index, :show], controller: 'merchants' do
        resources :items, only: [:index], controller: :merchant_items
        collection do
          get '/find', to: 'merchants#find'
        end
      end
      #items
      resources :items do
        resources :merchant, only: [:index], controller: :items_merchant
        collection do
          get '/find_all', to: 'items#find_all'
        end
      end
      #non-RESTful
      namespace :revenue do
        get '/unshipped', to: 'merchants#potential_revenue'
        get '/merchants', to: 'merchants#most_revenue'
        get '/merchants/:id', to: 'merchants#total_revenue'
        get '/items', to: 'items#most_revenue'
      end
    end
  end
end
