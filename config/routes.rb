Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'

      resources :merchants, only: [:index, :show], controller: 'merchants' do
        resources :items, only: [:index]
      end

      get '/items/find_all', to: 'items#find_all'

      # resources :items, only: [:index, :show, :create, :destroy, :update] do
      resources :items do
        resources :merchant, only: [:index], controller: :items_merchant
      end

      get 'revenue/merchants', to: 'merchants#most_revenue'
      get 'revenue/unshipped', to: 'merchants#potential_revenue'
      get 'revenue/merchants/:id', to: 'merchants#total_revenue'
      get 'revenue/items', to: 'items#most_revenue'
    end
  end
end
