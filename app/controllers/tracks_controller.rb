class TracksController < ApplicationController
  before_action :set_playlist, only: %i[ correct_user correct_user_or_editor new create update destroy ]
  before_action :correct_user, only: [:update, :destroy]
  before_action :correct_user_or_editor, only: [:new, :create]

  # GET /playlist/:id/tracks/new
  def new
    @track = Track.new
    @query = params[:query]
    @playlist = Playlist.find(params[:id])
    if @query.present?
      service = Search.new(Rails.application.credentials.youtube[:api_key])
      @results = service.search(@query).parsed_response['items']
    else
      @results = []
    end
  end
  
  # POST /tracks
  def create
    @track = Track.new
    @track.title = params[:track_title]
    @track.source = 'youtube'
    @track.track_id = params[:track_id]
    @track.playlist_id = params[:id]

    if current_user.id != Playlist.find(params[:id]).user_id
      @track.addedby = current_user.id
    end

    respond_to do |format|
      if @track.save
        format.html { redirect_to playlist_path(@playlist), notice: "Track was successfully added." }
        format.json { render :show, status: :created, location: @track }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  def destroy
    @playlist = Playlist.find(params[:playlist])
    @track = Track.find(params[:track])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to playlist_path(@playlist) }
      format.json { head :no_content }
    end
  end

  def reorder
    params[:item_ids].each_with_index do |id, index|
      Track.find(id).update(order: index + 1)
    end
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def track_params
      params.require(:track).permit(:title, :source, :track_id)
    end
    # Protect playlists from unauthorized users
    def correct_user
      unless current_user.id === @playlist.user_id
          redirect_to root_path, notice: "Sorry, you don't have access to that page."
      end
    end

    def correct_user_or_editor
      unless current_user.id === @playlist.user_id || @playlist.editors.ids.include?(current_user.id)
        redirect_to root_path, notice: "Sorry, you don't have access to that page."
      end
    end      
end
