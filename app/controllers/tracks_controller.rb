class TracksController < ApplicationController
  # GET /playlists/1/tracks
  def show
    @playlist = Playlist.find(params[:id])
    @user = User.find(@playlist.user_id)
    @tracks = @playlist.tracks
    @track_ids = @tracks.pluck(:track_id)
  end

  # GET /playlist/:id/tracks/new
  def new
    @playlist = Playlist.find(params[:id])
    @track = Track.new
    @query = params[:query]
    if @query.present?
      service = Search.new(Rails.application.credentials.youtube[:api_key])
      @results = service.search(@query).parsed_response['items']
    else
      @results = []
    end
  end
  
  # POST /tracks
  def create
    @playlist = Playlist.find(params[:id])
    @track = Track.new
    @track.title = params[:track_title]
    @track.source = 'youtube'
    @track.track_id = params[:track_id]
    @track.playlist_id = params[:id]

    respond_to do |format|
      if @track.save
        format.html { redirect_to view_playlist_path(@playlist), notice: "Track was successfully added." }
        format.json { render :show, status: :created, location: @track }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  def destroy
    @track.destroy

    respond_to do |format|
      format.html { redirect_to playlists_url, notice: "Track was removed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def track_params
      params.require(:track).permit(:title, :source, :track_id)
    end
end
