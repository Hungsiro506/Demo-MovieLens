Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  resources :movies, only: [:index, :show]
  resources :users, only: [:show]
  resources :categories, only: [:create, :destroy] do
    collection do
      post :like
      post :unlike
    end
  end

  delete '/remove_like/:id' => "categories#remove_like"
  get '/rate' => "movies#rate"
  get "search" => "search#search"
  get 'search/typeahead/:term' => 'search#typeahead'
end
