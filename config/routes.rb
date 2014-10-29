Rails.application.routes.draw do
  root to: 'high_voltage/pages#show', id: 'home'
  get '/contact', to: 'high_voltage/pages#show', id: 'contact'

  devise_for :users, controllers: { registrations: 'users/registrations' }
end
