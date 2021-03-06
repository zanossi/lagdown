Lagdown::Application.routes.draw do
  constraints subdomain: false do
    root 'home#index'
    devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations'}
    get 'select2/tags', format: :json
    get 'select2/results', format: :json

    get 'home/about' => 'home#about'

    post 'preview' => 'posts#preview'
    namespace :settings do
      resources :blogs do
        resources :posts, only: %i[new create edit update destroy]
      end
      resource :user, only: %i[edit update]
    end
  end

  constraints(Subdomain) do
    root 'posts#index', as: :blog_root

    
    get 'posts/rss' => 'posts#rss', as: :rss



    resources :posts, only: %i[index show]
  end 

  namespace :admin do
    root 'home#index'
    devise_for :administrators, class_name: Admin::Administrator, singular: :administrator
    resources :administrators
    resources :users
    resources :posts
    resources :blogs
  end
end
