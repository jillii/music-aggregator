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
end