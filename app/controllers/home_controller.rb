class HomeController < ApplicationController
    def index
        @playlists = Playlist.order(id: :desc).limit(10)
        @tags = Tag.order(id: :desc).limit(10)
    end

    def account
        @user = User.find(params[:id])
        @playlists = @user.playlists
        @followers = @user.followers
        @following = @user.following
        @editor_playlists = @user.playlists_editing
        @liked_playlists = @user.liked_playlists
        @collab_requests = @user.collab_requests_received
    end

    def users
        @users = User.where(nil)

        if params[:followers].present?
            user = User.find(params[:followers])  # Find the user with the given id
            @users = @users.merge(user.followers)  # Merge the following users into the query
          end
        if params[:following].present?
            user = User.find(params[:following])  # Find the user with the given id
            @users = @users.merge(user.following)  # Merge the following users into the query
        end

        @users = @users.where('lower(users.email) LIKE ? OR lower(users.username) LIKE ?', "%#{params[:search].downcase}%", "%#{params[:search].downcase}%") if params[:search].present?
        # @users = @users.where('users.id IS NOT ?', current_user.id) if current_user.present?
        @users = @users.where('users.confirmed_at IS NOT null').page params[:page]
    end
end