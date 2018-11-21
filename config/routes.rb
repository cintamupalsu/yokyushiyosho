Rails.application.routes.draw do

  root   'main_pages#home'
  get    '/home',    to: 'main_pages#home'
  get    '/help',    to: 'main_pages#help'
  get    '/about',   to: 'main_pages#about'
  get    '/contact', to: 'main_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  
end