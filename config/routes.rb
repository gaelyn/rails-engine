Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'

      resources :merchants, only: [:index, :show], controller: 'merchants' do
        resources :items, only: [:index]
      end

      get '/items/find_all', to: 'items#find_all'

      resources :items, only: [:index, :show, :create, :destroy] do
        resources :merchant, only: [:index], controller: :items_merchant
      end
    end
  end
end
