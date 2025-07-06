Rails.application.routes.draw do
  get 'errors/not_found'
  get 'errors/internal_server_error'
  get 'notifications', to: 'notifications#index', as: :user_notifications
  get 'notification/:id', to: 'notifications#show', as: :notification
  post 'notification/:id', to: 'notifications#read', as: :read_notification
  delete 'notification/:id', to: 'notifications#destroy'
  post 'notifications', to: 'notifications#read_all', as: :read_all_notifications

  resources :playlists do
    get '/page/:page', action: :index, on: :collection
    # liking routes
    resource :like, only: [:destroy, :create]
  end

  # Defines track reorder route
  post '/tracks/reorder', to: 'tracks#reorder'

  devise_for :users

  get 'users', to: 'home#users'
  post 'follows/create'
  delete 'follows/destroy'
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  root to: "home#index"
  get 'users/:id', to: 'home#account', as: :user_account
  get 'about', to: 'home#about', as: :about

  # Defines route to search
  get '/playlists/:id/tracks/new', to: 'tracks#new', as: :search_tracks
  put '/playlists/:id/tracks/new', to: 'tracks#create', as: :add_track

  # Defines route to add editors to playlist
  get '/playlists/:id/editors/new', to: 'playlists#search_editors', as: :search_users
  put '/playlists/:id/editors/new', to: 'playlists#add_editor', as: :add_editor
  put 'playlists/:id/editor/:editor_id', to: 'playlists#delete_editor'
  
  post 'playlists/:id/collab_requests/create', to: 'collab_requests#create', as: :collab_request
  get 'collab_requests/:id', to: 'collab_requests#show', as: :collab_request_view
  put 'collab_requests/:id/accept', to: 'collab_requests#accept_request', as: :accept_request
  delete 'collab_requests/:id/destroy', to: 'collab_requests#destroy', as: :collab_requests_destroy

  # Defines delete for tags
  delete 'tags/:id', to: 'tags#destroy'

  # Defines delete for tracks
  delete 'tracks/:id', to: 'tracks#destroy'

  # errors
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
