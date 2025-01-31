Rails.application.routes.draw do

  resources :posts do
    get :first, on: :collection
  end

  devise_for :users, skip: [:registrations]


  # Área de administración protegida
  namespace :admin do
    resources :products do  # CRUD de productos
        patch :change_stock, on: :member
        resources :product_variants, only: [:new, :create, :edit, :update, :destroy]
    end

    resources :users do
      member do
        patch :deactivate
      end
    end

    resources :sales do  # Gestión de ventas
      patch :cancel, on: :member
    end
    
    root 'dashboard#index'  # Página principal del admin
  end

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
    # Storefront público
    root 'storefront#home'  # Página principal

    get "storefront", to: "storefront#home", as: :storefront_home
    get "storefront/:id", to: "storefront#show", as: :storefront_product
    resources :products, only: [:index, :show]  # Ver productos sin registro
end
