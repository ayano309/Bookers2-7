Rails.application.routes.draw do
  root to: 'homes#index'
  get "home/about" => "homes#about", as: "about"

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books do
   resources :comments, only: [:create, :destroy]
   resource :favorites, only: [:create, :destroy]
  end

  resources :users ,only: [:index, :show, :edit, :update] do
   resources :follows, only: [:create]
   resources :unfollows, only: [:create]
   resources :followings, only: [:index]
   resources :followers, only: [:index]
  end

  get "search" => "searches#search"

  # DM
  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]

end
