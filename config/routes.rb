Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'pages#explore'

  get 'explorer', to: 'pages#explore', as: :explore
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  post 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :users, only: [:show] do
    member do
      post 'remove_skill'
      post 'add_skill'
      post 'set_rate'

      get 'calendar'
      post 'mark_calendar'
    end
  end

  resources :events, only: [:new, :create] do
    member do
      post 'join'
    end
  end
end
