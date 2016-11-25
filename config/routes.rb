Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  resources :movies, only: [:index, :show]
  resources :users, only: [:show]

end
