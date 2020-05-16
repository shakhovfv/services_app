Rails.application.routes.draw do
  #resources :kladrs
  #resources :jurisdictions
  #resources :users
  #get 'user/name'
  #get 'user/email'
  #resources :addresses
  # constraints subdomain: 'api' do
  #   scope module: 'api' do
  #     namespace :v1 do
  #       resources :subjects
  #       resources :types
  #       resources :courts
  #     end
  #   end
  # end

  scope module: 'api' do
    namespace :v1 do
      namespace :cases do
        resources :subjects
        resources :courts
        resources :types
        get '/cases', to: "cases#index"
      end
      namespace :addresses do
        resources :addresses
        resources :districts
        resources :localities
        resources :locality_types
        resources :location_types
      end
      namespace :jurisdictions do
        resources :jurisdictions
      end
      get '/kladr', to: "kladr#index"
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
