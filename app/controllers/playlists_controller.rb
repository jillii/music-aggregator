class PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[ show edit update destroy ]

  # GET /playlists or /playlists.json
  def index
    @playlists = Playlist.all
  end

  # GET /playlists/1 or /playlists/1.json
  def show
    @title = @playlist.title
    @image = @playlist.image
    @tracks = @playlist.tracklist.split(', ')
    @user_id = @playlist.user_id
    @user = User.find(@user_id).email
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists or /playlists.json
  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.user_id = current_user.id

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to playlist_url(@playlist), notice: "Playlist was successfully created." }
        format.json { render :show, status: :created, location: @playlist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1 or /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to playlist_url(@playlist), notice: "Playlist was successfully updated." }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1 or /playlists/1.json
  def destroy
    @playlist.destroy

    respond_to do |format|
      format.html { redirect_to playlists_url, notice: "Playlist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    @playlist = Playlist.find(params[:id])
    @query = params[:query]
    if @query.present?
      service = Search.new(Rails.application.credentials.youtube[:api_key])
      @results = service.search(@query).parsed_response['items']
    else
      @results = []
    end
  end

  def addTrack
    @playlist = Playlist.find(params[:id])
    @tracklist = @playlist.tracklist
    @track = params[:track]
    if (!@tracklist || @tracklist == '')
      @playlist.update(:tracklist => "'#{@track}'")
    else
      @playlist.update(:tracklist => @playlist.tracklist + ", '#{@track}'")
    end

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to search_path(@playlist), notice: "Playlist was successfully updated." }
        format.json { render :show, status: :updated, location: @playlist }
      else
        format.html { render :search, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def playlist_params
      params.require(:playlist).permit(:title, :image, :tracklist)
    end
end
