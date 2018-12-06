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

  #get 'password_resets/new'
  #get 'password_resets/edit'
  
  get    '/shiyosho',          to: 'yokyushiyosho#sakusei'
  post   '/shiyosho',          to: 'yokyushiyosho#sakusei'
  post   '/shiyosho_torikomi', to: 'yokyushiyosho#create_torikomi'
  post   '/shiyosho_sakusei',  to: 'yokyushiyosho#create_sakusei'
  get    '/similar',           to: 'yokyushiyosho#similar'
  post   '/similar_post',      to: 'yokyushiyosho#similar_post'


  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  resources :yokyu_parents
  post '/yokyu_parents_default', to: 'yokyu_parents#default'
  resources :yokyu_children
  post '/yokyu_children/new', to: 'yokyu_children#new'
  
  resources :companies
  resources :file_managers
  
end