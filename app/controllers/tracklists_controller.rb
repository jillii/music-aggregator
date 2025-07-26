class TracklistsController < ApplicationController
  before_action :correct_user, only: [ :index, :edit, :destroy ]
  def index
    @tracklist = current_user && current_user.tracklist
  end

  def new
    @tracklist = Tracklist.new
  end

  def create
    current_user.tracklist.destroy if current_user && current_user.tracklist # remove existing tracklist, if any
    
    @tracklist = Tracklist.new(tracklist_params)
    
    @tracklist.user = current_user
    track_ids = tracklist_params[:track_ids].map(&:to_i)
    
    if track_ids
      track_ids.each do |t|
        @tracklist.tracks << Track.find(t)
      end
    end
    
    respond_to do |format|
      if @tracklist.save
        format.html { redirect_back(fallback_location: root_path) }
      else
        format.html { redirect_back(fallback_location: root_path) }
      end
    end
  end

  def edit    
    @tracklist = current_user && current_user.tracklist || Tracklist.new(user: current_user)
    
    track_ids = tracklist_params[:track_ids].map(&:to_i)
    
    if track_ids
      track_ids.each do |t|
        @tracklist.tracks << Track.find(t)
      end
    end
    
    respond_to do |format|
      if @tracklist.save
        format.html { redirect_back(fallback_location: root_path) }
      else
        format.html { redirect_back(fallback_location: root_path) }
      end
    end
  end

  def destroy
    current_user.tracklist.destroy if current_user

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  # Protect tracklists from unauthorized users
  def correct_user
    @tracklist = Tracklist.find(params[:id])
    @is_user = current_user && @tracklist && current_user.id === @tracklist.user_id
    unless @is_user
        redirect_to user_account_path(current_user)
    end
  end

  private

  def tracklist_params
    params.require(:tracklist).permit(:track_ids => [])
  end
end
