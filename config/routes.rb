Rails.application.routes.draw do
  devise_for :users
  resources :homes
  resources :pets
  resources :users, only: [:show] do
    collection do 
      get :profile
    end
  end

  root "pages#home"
end
