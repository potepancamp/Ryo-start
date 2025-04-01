Rails.application.routes.draw do
  resources :products, only: [:show]
  mount Spree::Core::Engine, at: '/spree'

  root to: 'home#index'

  resources :cart, only: :index, controller: 'cart'
end
