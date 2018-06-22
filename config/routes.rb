Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'

  get 'users/index'

  resources :posts, :except => [:new] do
    resources :comments, only: [:create, :destroy]
  end

end
