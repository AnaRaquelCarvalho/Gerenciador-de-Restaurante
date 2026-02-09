Rails.application.routes.draw do
  # Agrupa todas as rotas administrativas sob o prefixo /admin
  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end
    resources :categories
  end

  # Configuração do Devise para Admins
  devise_for :admins

  # Rota que redireciona o admin autenticado para o dashboard
  authenticated :admin do
    root to: "admin#index", as: :admin_root
  end

  # Atalho para o painel administrativo
  get "admin" => "admin#index"

  # Rota principal da loja (página inicial do cliente)
  root "home#index"
end
