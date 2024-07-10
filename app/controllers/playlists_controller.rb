class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [ :correct_user, :show, :edit, :update, :destroy ]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /playlists or /playlists.json
  def index
    @playlists = Playlist.order(:title).page params[:page]
  end

  # GET /playlists/1
  def show
    @user = User.find(@playlist.user_id)
    @tracks = @playlist.tracks
    @track_ids = @tracks.pluck(:track_id)
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
        format.html { redirect_to playlist_path(@playlist), notice: "Playlist was successfully created." }
        format.json { render :show, status: :created, location: @playlist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1 or /playlists/1.json
  def update
    tags = params[:playlist][:tag_id].split(',')

    tags.each do |tag|
      Tag.create(label: tag.strip, playlist_id: @playlist.id)
    end

    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to playlist_path(@playlist), notice: "Playlist was successfully updated." }
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

  # GET /playlists/searchby
  def searchby
    @query = params[:search]

    if @query 
      @title = Track.find_by(track_id: @query).title

      @playlists = Playlist.includes(:tracks).where(tracks: {track_id: params[:search]})
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def playlist_params
      params.require(:playlist).permit(:title, :image)
    end

    # Protect playlists from unauthorized users
    def correct_user
      unless current_user.id === @playlist.user_id
          redirect_to user_path(current_user)
      end
    end
end
