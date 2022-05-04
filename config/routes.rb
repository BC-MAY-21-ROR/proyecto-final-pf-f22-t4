Rails.application.routes.draw do
  devise_for :users
  resources :homes
  resources :pets

  root "pages#home"
end
