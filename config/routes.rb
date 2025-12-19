Rails.application.routes.draw do
  devise_for :admins

  namespace :admin do
    root to: "categories#index"
    resources :categories
    resources :products
  end

  root to: "home#index"
end
