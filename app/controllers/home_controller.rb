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
            followers_followees = current_user.followers.ids + current_user.following.ids

            if @search and @search != ''
                search_query = "%#{@search.downcase}%"
                @users = User.where("lower(email) LIKE ? OR lower(username) LIKE ? AND id IS NOT ? AND confirmed_at IS NOT null", search_query, search_query, current_user.id)
                             .order(User.arel_table[:id].in(followers_followees).desc.nulls_last).page params[:page]
            else  
                @users = User.where("id IS NOT ? AND confirmed_at IS NOT null", current_user.id)
                             .order(User.arel_table[:id].in(followers_followees).desc.nulls_last).page params[:page]
            end
        end
    end
end