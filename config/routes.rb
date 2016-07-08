Rails.application.routes.draw do
  root 'pages#homepage'

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  post 'sign_out', to: 'sessions#destroy', as: :sign_out
end
