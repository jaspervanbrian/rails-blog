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
  resources :users, only: [:show, :update] do
    member do
      patch :update_photo_avatar
      put :update_photo_avatar

      patch :update_photo_banner
      put :update_photo_banner

      patch :update_password
      put :update_password
    end
    resources :posts, only: [:create]
  end

  # Posts and comments
  resources :posts, :except => [:new] do
    resources :comments, only: [:create, :destroy]

    member do
      delete :delete_image_attachment
    end
  end

  # Conversations and messages
  resources :conversations do
    resources :messages, only: [:index, :create]
  end
end
