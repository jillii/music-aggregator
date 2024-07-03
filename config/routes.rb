Rails.application.routes.draw do
  resources :playlists, :only => [:index, :show, :new, :create, :edit, :update]
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "home#index"

  # Defines route to search
  get '/playlists/:id/add', to: 'playlists#search', as: :search
  put '/playlists/:id/add', to: 'playlists#addTrack', as: :add_track
end
