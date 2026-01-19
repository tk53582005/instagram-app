Rails.application.routes.draw do
  devise_for :users
  
  # ログイン後はタイムラインへ
  authenticated :user do
    root to: 'posts#index', as: :authenticated_root
  end
  
  # 未ログインはログインページへ
  root to: redirect('/users/sign_in')
  
  # 投稿機能
  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    resource :like, only: [:create, :destroy]
  end
  
  # プロフィールページ
  get '/profile/:username', to: 'profiles#show', as: :profile
  get '/profile/:username/edit', to: 'profiles#edit', as: :edit_profile
  patch '/profile/:username', to: 'profiles#update'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end