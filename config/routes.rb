Rails.application.routes.draw do
  get 'events/new'

  get 'events/create'

  get 'users/show'

  root 'pages#homepage'

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

  resources :events, only: [:new, :create]
end
