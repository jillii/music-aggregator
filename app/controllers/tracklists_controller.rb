class TracklistsController < ApplicationController
  before_action :current, only: [ :edit, :destroy ]

  def new
    @tracklist = Tracklist.new
  end

  def create
    session_id = session.id.to_s
    Tracklist.find_by(session: session_id).destroy if Tracklist.find_by(session: session_id) # remove existing tracklist, if any

    @tracklist = Tracklist.new(tracklist_params)
    @tracklist.session = session_id

    track_ids = tracklist_params[:track_ids].map(&:to_i)
    
    track_ids.each do |t|
      @tracklist.tracks << Track.find(t)
    end

    respond_to do |format|
      if @tracklist.save
        format.html { render partial: 'layouts/tracklist' }
      end
    end
  end

  def edit
    session_id = session.id.to_s
    @tracklist =  Tracklist.new(session: session_id) unless @tracklist.present?
    @tracklist.tracks.delete_all
    track_ids = tracklist_params[:track_ids].map(&:to_i)
    
    if track_ids
      track_ids.each do |t|
        @tracklist.tracks.push(Track.find(t))
      end
    end
    
    respond_to do |format|
      if @tracklist.save
        @active = true
        format.html { render partial: 'layouts/tracklist' }
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

  
  private

  # get current tracklist
  def current
    @tracklist = Tracklist.find_by(session: session.id.to_s)
  end

  def tracklist_params
    params.require(:tracklist).permit(:track_ids => [])
  end
end
