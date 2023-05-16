Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'

  # static
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  ## user
  get '/signup', to: 'users#new'
  # get '/edit', to: 'users#edit'

  ## session
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :api, format: 'json' do
    resource :token, only: [:create]
    resources :users, only: %i[show create destroy]
  end

  resources :users do
    # memberメソッド
    # urlの深掘りオプション
    #
    # Prefix Verb            URI Pattern                      Controller#Action
    # following_user GET    /users/:id/following(.:format)    users#following

    ## ひとつなら下のようにかける
    ## resources :users do
    ##  get :followings, on: :member
    ## end
    member { get :following, :followers }
  end

  resources :users # users/{id}のURLが有効になる
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  get '/microposts', to: 'static_pages#home'
end
