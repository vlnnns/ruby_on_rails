Rails.application.routes.draw do
  get "genres/index"
  get "genres/show"
  get "genres/new"
  get "genres/edit"
  get "authors/index"
  get "authors/show"
  get "authors/new"
  get "authors/edit"
  get "users/new"
  resources :books
  resources :users, only: [:new, :create]
  resource :account, only: [:destroy], controller: 'users'
  resources :authors, only: [:index, :show]
  resources :genres, only: [:index, :show]


  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root 'books#index'
end
