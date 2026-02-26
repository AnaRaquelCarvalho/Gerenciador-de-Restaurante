Rails.application.routes.draw do
  # =========================
  # ADMIN (Painel de Gerenciamento)
  # =========================
  devise_for :admins

  authenticated :admin do
    root to: "admin#index", as: :admin_root
  end

  get "admin", to: "admin#index"

  namespace :admin do
    # Adicionamos 'member' para permitir ações como 'marcar como preparado'
    resources :orders do
      member do
        patch :mark_as_paid
        patch :mark_as_shipped
      end
    end

    resources :products do
      resources :stocks
    end

    resources :categories
  end

  # =========================
  # LOJA (Experiência do Cliente)
  # =========================
  root "home#index"

  # Gerenciamento do Carrinho
  resource :cart, only: [ :show, :destroy ] do
    post "add/:product_id", to: "carts#add", as: :add_to
    delete "remove/:product_id", to: "carts#remove", as: :remove_from
  end

  # Categorias e Produtos (Acesso do Cliente)
  resources :categories, only: [ :show ]
  resources :products, only: [ :show ]

  # =========================
  # SISTEMA DE PAGAMENTO (Stripe)
  # =========================

  # Criar a sessão de checkout
  resources :checkouts, only: [ :create ] do
    collection do
      get "success" # Onde o cliente cai após pagar
      get "cancel"  # Onde o cliente cai se desistir
    end
  end

  # Webhook: O Stripe avisa seu servidor por aqui (Essencial!)
  # Usamos um caminho que o Stripe recomenda não mudar
  post "webhooks/stripe", to: "webhooks#stripe"

  # =========================
  # HEALTH CHECK
  # =========================
  get "up" => "rails/health#show", as: :rails_health_check
end
