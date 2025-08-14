Rails.application.routes.draw do

  # API
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "authentication#login"
      post "auth/logout", to: "authentication#logout"
      post "auth/refresh", to: "authentication#refresh"
      get "auth/testToken", to: "authentication#testToken"
      post "payment", to: "payment#create"
      post 'payment/webhook', to: 'payment_webhook#receive'

      resources :home, only: [:index]
      resources :products, only: [:index, :show]
      resources :categories, only: [:index, :show]
      resources :wish_lists, only: [:index]
      resources :orders, only: [:index, :create, :update, :show]
    end
    # namespace :v2 do
    #   resources :products, only: [:index]
    # end
  end

  #======END API========
  resources :roles do
    member do
      get :authorize
      patch :set_permissions
    end
  end
  resources :orders
  resources :sizes do
    member do
      patch :restore
    end
  end
  resources :colors do
    member do
      patch :restore
    end
  end
  resources :products do
    member do
      patch :restore
    end
    resources :product_variants do
      member do
        patch :restore
      end
    end
  end
  resources :categories do
    member do
      patch :restore
    end
  end
  resources :users do
    member do
      patch :restore
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"
  devise_for :users, path: 'auth',
             controllers: {
               sessions: 'authentication/sessions',
               registrations: 'authentication/registrations',
               confirmations: 'authentication/confirmations',
               passwords: 'authentication/passwords',
             }
end
