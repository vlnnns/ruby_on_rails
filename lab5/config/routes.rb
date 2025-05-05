Rails.application.routes.draw do
  get "users/new"
  resources :books
  resources :users, only: [:new, :create]
  resource :account, only: [:destroy], controller: 'users'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root 'books#index'
end
