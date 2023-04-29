Rails.application.routes.draw do
  get 'up', to: "healthcheck#show"
  
  root "application#hello"
end
