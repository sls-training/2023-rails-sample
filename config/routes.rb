Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  
  # static
  root 'static_pages#home'
  get '/help', to:'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  
  ## user
  get '/signup', to: 'users#new'
  #get '/edit', to: 'users#edit'
  
  ## session
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users # users/{id}のURLが有効になる
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  get '/microposts', to: 'static_pages#home'
end
