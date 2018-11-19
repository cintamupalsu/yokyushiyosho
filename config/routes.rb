Rails.application.routes.draw do
  root 'main_pages#home'
  get  'main_pages/home'
  get  'main_pages/help'
  get  'main_pages/about'
  
end
