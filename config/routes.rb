Rails.application.routes.draw do
  namespace :admin do
    resources :categories
    resources :products
  end

  # Devise para admins
  devise_for :admins

  # Root para admin autenticado
  authenticated :admin do
    root to: "admin#index", as: :admin_root
  end

  # Rota direta para admin#index
  get "admin", to: "admin#index"

  # Root padrão para usuários não autenticados
  root to: "home#index"
end
