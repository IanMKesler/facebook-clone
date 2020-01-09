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
    resources :posts, only: [:create, :index, :destroy]
  end
end
