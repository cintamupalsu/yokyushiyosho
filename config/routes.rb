Rails.application.routes.draw do
  get 'users/new'
  root 'main_pages#home'
  get  '/home',    to: 'main_pages#home'
  get  '/help',    to: 'main_pages#help'
  get  '/about',   to: 'main_pages#about'
  get  '/contact', to: 'main_pages#contact'
  get  '/signup',  to: 'users#new'
  resources :users
  
end
