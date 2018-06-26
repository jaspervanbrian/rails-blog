Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'

  # Auth
  get 'login', to: 'authentication#login'
  post 'login', to: 'authentication#attempt'
  post 'logout', to: 'authentication#logout'

  # Users
  get 'sign_up', to: 'users#new'
  post 'sign_up', to: 'users#create'

  # Posts and comments
  resources :posts, :except => [:new] do
    resources :comments, only: [:create, :destroy]
  end

end
