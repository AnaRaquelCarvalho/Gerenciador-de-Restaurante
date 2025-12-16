Rails.application.routes.draw do
  devise_for :admins

  authenticated :admin do
    root to: "admin#index", as: :authenticated_root
  end

  root "home#index"
end
