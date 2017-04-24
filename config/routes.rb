Rails.application.routes.draw do
  scope module: :v1, constraints: Constraints::ApiVersion.new(version: 1, default: true) do
    get :whoami, to: 'whoami#show'
    namespace :auth do
      resources :tokens, only: [:create]
    end
    resources :registrations, onliy: [:create]
    resources :members
    resources :products do
      resources :variants
    end
    resources :countries, only: [:index]
    resources :provinces, only: [:index]
    resources :sale_taxes
    resources :customers do
      resources :addresses
    end
    resources :orders do
      resources :line_items
    end

    match '*path', to: 'errors#catch_404', via: :all
  end
end
