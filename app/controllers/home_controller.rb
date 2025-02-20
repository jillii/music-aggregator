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
        if params[:followers]
            @users = User.find(params[:followers]).followers.page(params[:page])
        elsif params[:following]
            @users = User.find(params[:following]).following.page(params[:page])
        else  
            @search = params[:search]
            if @search and @search != ''
                search_query = "%#{@search.downcase}%"
                @users = User.where("lower(email) LIKE ? OR lower(username) LIKE ?", search_query, search_query).page params[:page]
            else  
                @users = User.all.page(params[:page])
            end
        end
    end
end