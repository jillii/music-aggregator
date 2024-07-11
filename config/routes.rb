Rails.application.routes.draw do
  resources :playlists do
    get '/page/:page', action: :index, on: :collection
  end

  # Defines track reorder route
  post '/tracks/reorder', to: 'tracks#reorder'

  devise_for :users
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  root to: "home#index"
  get 'users/:id', to: 'home#account', as: :user_account

  # Defines route to search
  get '/playlists/:id/tracks/new', to: 'tracks#new', as: :search_tracks
  put '/playlists/:id/tracks/new', to: 'tracks#create', as: :add_track

  # Defines delete for tags
  delete 'tags/:id', to: 'tags#destroy'

  # Defines delete for tracks
  delete 'tracks/:id', to: 'tracks#destroy'
end
