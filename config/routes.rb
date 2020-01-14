Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    root to: "users/sessions#new"
  end

  resources :users, only: [:show, :index] do
    resources :friend_requests, only: [:create, :index, :destroy]
    resources :friendships, only: [:create, :index, :destroy], path: :friends, as: :friends
    resources :posts, only: [:create, :index, :destroy] do
      resources :comments, only: [:create, :destroy]
      resources :likes, only: [:create]
    end
    resources :comments, only: [:create, :destroy, :index] do
      resources :comments, only: [:create, :destroy]
      resources :likes, only: [:create]
    end
    resources :likes, only: [:index, :destroy]
  end
end
