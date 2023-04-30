Rails.application.routes.draw do
  resources :microposts
  resources :users
  
  get 'up', to: "healthcheck#show"
  root "users#index"
end
