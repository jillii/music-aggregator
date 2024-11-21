class LikesController < ApplicationController
  before_action :authenticate_user!
      
  def create
    @playlist = Playlist.find(params[:playlist_id])
    current_user.likes.create!(playlist: @playlist)

    notification = Notification.new(
      message: "<a href='/users/#{current_user.id}'>#{current_user.username ? current_user.username : current_user.email}</a> likes <a href='/playlists/#{@playlist.id}'>#{@playlist.title}</a>",
      sender_id: current_user.id,
      recipient_id: @playlist.user_id,
      read: false
    )

    respond_to do |format|
      notification.save
      format.html { redirect_to playlist_path(@playlist)}
    end
  end

  def destroy
    @playlist = Playlist.find(params[:playlist_id])
    like = current_user.likes.find_by(playlist: @playlist)
    like.destroy if like

    respond_to do |format|
      format.html { redirect_to playlist_path(@playlist)}
    end
  end
end