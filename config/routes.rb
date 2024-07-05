Rails.application.routes.draw do
  resources :playlists, :only => [:new, :create, :edit, :update]
  resources :playlists do
    get '/page/:page', action: :index, on: :collection
  end
  devise_for :users
  
  get '/playlists/:id/tracks', to: 'tracks#show', as: :view_playlist
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  root to: "home#index"
  get 'users/:id', to: 'home#account', as: :user_account

  # Defines route to search
  get '/playlists/:id/tracks/new', to: 'tracks#new', as: :search_tracks
  put '/playlists/:id/tracks/new', to: 'tracks#create', as: :add_track
end
