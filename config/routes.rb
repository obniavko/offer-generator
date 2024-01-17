Rails.application.routes.draw do
  root 'offers#index'

  devise_for :users
  resources :offers
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
