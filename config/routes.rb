Rails.application.routes.draw do
  resources :playlists, :only => [:index, :show, :new, :create, :edit, :update]
  devise_for :users

  get '/playlists/:id/tracks', to: 'tracks#show', as: :view_playlist
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "home#index"

  # Defines route to search
  get '/playlists/:id/tracks/new', to: 'tracks#new'
  put '/playlists/:id/tracks/new', to: 'tracks#create', as: :add_track
end
