Rails.application.routes.draw do
  devise_for :users
  # get 'articles/index'
  root 'articles#index'

  resources :articles 

  resources :searches, only: [:create]

  get '/search', to: 'articles#search'
  resources :articles do
    collection do
      get :analytics
    end
  end


end
