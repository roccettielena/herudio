Rails.application.routes.draw do
  root to: 'courses#index'
  get '/contact', to: 'high_voltage/pages#show', id: 'contact'

  resources :courses, only: [:index, :show]

  devise_for :users, controllers: { registrations: 'users/registrations' }
end
