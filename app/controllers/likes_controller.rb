class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @playlist = Playlist.find(params[:playlist_id])
    current_user.likes.create!(playlist: @playlist)
    # redirect_to @playlist, notice: 'Playlist liked!'
  end

  def destroy
    @playlist = Playlist.find(params[:playlist_id])
    like = current_user.likes.find_by(playlist: @playlist)
    like.destroy if like
    # redirect_to @playlist, notice: 'Playlist unliked!'
  end
end