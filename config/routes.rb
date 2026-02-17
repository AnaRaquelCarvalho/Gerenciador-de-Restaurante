Rails.application.routes.draw do
  # --- SILENCIAR ERROS DE NAVEGADOR ---
  get "/.well-known/appspecific/com.chrome.devtools.json", to: proc { [ 204, {}, [ "" ] ] }
  get "/favicon.ico", to: proc { [ 204, {}, [ "" ] ] }

  # --- ROTAS DE ADMIN ---
  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end
    resources :categories
  end

  devise_for :admins

  # --- AUTENTICAÇÃO ---
  authenticated :admin_user do
    root to: "admin#index", as: :admin_root
  end

  # --- CARRINHO (IMPORTANTE: Antes de :products e :categories) ---
  # Isso garante que /cart ou /carts nunca sejam confundidos com IDs de produtos
  resource :cart, controller: "carts", only: [ :show, :create, :destroy ]
  get "carts", to: "carts#show" # Atalho para aceitar o plural no navegador

  # --- LOJA ---
  resources :categories, only: [ :show ]
  resources :products, only: [ :show ]

  get "admin" => "admin#index"
  root "home#index"
end
