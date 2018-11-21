Rails.application.routes.draw do

  get 'password_resets/new'
  get 'password_resets/edit'
  root   'main_pages#home'
  get    '/home',    to: 'main_pages#home'
  get    '/help',    to: 'main_pages#help'
  get    '/about',   to: 'main_pages#about'
  get    '/contact', to: 'main_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  get    '/shiyosho',          to: 'yokyushiyosho#sakusei'
  post   '/shiyosho_torikomi', to: 'yokyushiyosho#torikomi'
  post   '/shiyosho_sakusei',  to: 'yokyushiyosho#sakusei'

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  
end