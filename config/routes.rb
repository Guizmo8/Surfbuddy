Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users' }
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :surfspots, only: %i[index show] do
    resources :favourites, only: %i[create destroy]
    patch "/change_fav_alert_pref", to: "favourites#change_fav_alert_pref"
  end

  resources :favourites do
    collection do
      get :my_feed
    end
  end

  resources :favourites, only: %i[index]
  resources :alerts, only: %i[index]

end
