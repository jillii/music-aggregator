Rails.application.routes.draw do
  resources :playlists
  get 'playlists/new'
  get 'playlists/create'
  get 'playlists/update'
  get 'playlists/edit'
  get 'playlists/destroy'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "home#index"
end
