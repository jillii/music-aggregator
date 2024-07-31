class LikesController < ApplicationController
  before_action :authenticate_user!
      
  def create
    @playlist = Playlist.find(params[:playlist_id])
    current_user.likes.create!(playlist: @playlist)
    
    respond_to do |format|
      format.js   # This will look for create.js.erb
    end
  end

  def destroy
    @playlist = Playlist.find(params[:playlist_id])
    like = current_user.likes.find_by(playlist: @playlist)
    like.destroy if like

    respond_to do |format|
      format.js   # This will look for destroy.js.erb
    end
  end
end