Rails.application.routes.draw do
  scope module: :v1, constraints: Constraints::ApiVersion.new(version: 1, default: true) do
    resources :registrations, onliy: [:create]
    constraints Constraints::Subdomain.new do
      get :whoami, to: 'whoami#show'
      namespace :auth do
        resources :tokens, only: [:create]
      end
      resources :members
      resources :products do
        resources :variants
      end
      resources :shipping_carriers, only: [:index] do
        resources :shipping_services, only: [:index], as: :services
      end
      resources :countries, only: [:index]
      resources :provinces, only: [:index]
      resources :tax_rates
      resources :shipping_methods
      resources :shipping_accounts
      resources :zones
      resources :customers do
        resources :addresses
      end
      resources :orders do
        resources :line_items
      end
      match '*path', to: 'errors#catch_404', via: :all
    end
  end
end
