Rails.application.routes.draw do
  resources :users
  root 'users#new'
  get ':mistaken_name', to: 'users#challenge'
end
