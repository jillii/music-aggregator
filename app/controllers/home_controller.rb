class HomeController < ApplicationController
    def index
        @playlists = Playlist.order(id: :desc).limit(10)
        @tags = Tag.order(id: :desc).limit(10)
    end

    def account
        @user = User.find(params[:id])
        @playlists = @user.playlists
        @editor_playlists = @user.playlists_editing
    end

    def users
        @search = params[:search]
        if @search and @search != ''
            search_query = "%#{@search.downcase}%"
            @users = User.where("lower(email) LIKE ? OR lower(username) LIKE ?", search_query, search_query).page params[:page]
        else  
            @users = User.all.page(params[:page])
        end
    end
end