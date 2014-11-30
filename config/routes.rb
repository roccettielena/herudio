Rails.application.routes.draw do
  root to: 'high_voltage/pages#show', id: 'home'

  resources :courses, only: :index

  resources :courses, only: [:index, :show] do
    resources :lessons, only: [] do
      resource :subscription, only: [:create, :destroy]
    end
  end

  resources :subscriptions, only: :index

  devise_for :users, controllers: { registrations: 'users/registrations', invitations: 'users/invitations' }
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
end
