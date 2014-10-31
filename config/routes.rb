Rails.application.routes.draw do
  root to: 'courses#index'
  get '/contact', to: 'high_voltage/pages#show', id: 'contact'

  resources :courses, only: [:index, :show] do
    resources :lessons, only: [] do
      resource :subscription, only: [:create, :destroy]
    end
  end

  resources :subscriptions, only: :index

  devise_for :users, controllers: { registrations: 'users/registrations' }
end
