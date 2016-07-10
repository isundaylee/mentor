Rails.application.routes.draw do
  get 'users/show'

  root 'pages#homepage'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  post 'sign_out', to: 'sessions#destroy', as: :sign_out

  resources :users, only: [:show] do
    member do
      post 'remove_skill'
      post 'add_skill'

      get 'calendar'
      post 'mark_calendar'
    end
  end
end
