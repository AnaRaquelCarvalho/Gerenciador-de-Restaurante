Rails.application.routes.draw do
  # 1. Autenticação (Devise)
  devise_for :admins

  # 2. Área Administrativa (Namespace)
  namespace :admin do
    resources :orders
    resources :categories
    resources :products do
      resources :stocks
    end
    # Rota raiz do admin (dentro do namespace)
    root to: "admin#index"
  end

  # 3. Área Pública (O que o cliente vê)
  resources :categories, only: [ :show ]
  resources :products, only: [ :show ]

  # 4. Raiz da Aplicação (Página inicial do site)
  root "home#index"

  # Atalho para o painel admin (opcional)
  get "admin" => "admin#index"
end
