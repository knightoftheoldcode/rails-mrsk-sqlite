Rails.application.routes.draw do
  get 'up', to: "healthcheck#show"

  resources :users
  
  root "users#index"
end
