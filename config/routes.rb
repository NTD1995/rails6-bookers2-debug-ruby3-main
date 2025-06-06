Rails.application.routes.draw do
  get 'relationships/create'
  get 'relationships/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 devise_for :users  
  root :to =>"homes#top"
  get "home/about"=>"homes#about"

   resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
   resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
 
   resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
     get "followers" => "relationships#followers", as: "followers"
  	 get "followeds" => "relationships#followeds", as: "followeds"
     get "daily_posts" => "users#daily_posts"
  end

  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]

  get "/search", to: "searches#search"

  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
       resource :group_users, only: [:create, :destroy]
           resources :event_notices, only: [:new, :create]
             get "event_notices" => "event_notices#sent"
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "tag_searches/search" => "tag_searches#search"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  resources :notifications, only: [:update]
      
end