Rails.application.routes.draw do
  resources :forecasts, only: [:create, :show]
end