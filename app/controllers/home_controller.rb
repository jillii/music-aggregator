class HomeController < ApplicationController
    def index
        render
    end

    def account
        @user = User.find(params[:id])
        @playlists = @user.playlists
    end
end