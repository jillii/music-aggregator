class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [ :correct_user, :correct_editor, :show, :edit, :update, :destroy, :add_editor, :search_editors ]
  before_action :correct_user, only: [:edit, :update, :destroy, :add_editor, :search_editors]
  before_action :correct_editor, only: [ :show ]

  # GET /playlists or /playlists.json
  def index
    @track = params[:track]
    @tag = params[:tag]
    @search = params[:search]
    
    if @search
      @title = @search
      search_query = "%#{@search.downcase}%"

      by_tag = Tag.where("lower(label) LIKE ?", search_query).pluck(:playlist_id)
      by_track = Track.where("lower(title) LIKE ?", search_query).pluck(:playlist_id)
      children_search = by_tag.union(by_track)

      @playlists = Playlist.where("lower(title) LIKE ? OR id IN (?)", search_query, children_search).page params[:page]

    elsif @track 
      @title = Track.find_by(track_id: @track).title
      
      @playlists = Playlist.includes(:tracks).where(tracks: {track_id: @track}).order(:title).page params[:page]
    elsif @tag
      @title = @tag
      
      @playlists = Playlist.includes(:tags).where(tags: {label: @tag}).order(:title).page params[:page]
    else
      @playlists = Playlist.order(:title).page params[:page]
    end
  end

  # GET /playlists/1
  def show
    @user = User.find(@playlist.user_id)
    @tracks = @playlist.tracks
    @track_ids = @tracks.pluck(:track_id)
    @is_user = current_user && current_user.id === @playlist.user_id
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # POST /playlists or /playlists.json
  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.user_id = current_user.id

    tags = params[:playlist][:tag_id].split(',')
    tags_attributes = []

    tags.each do |tag|
      tags_attributes.push({:label => tag})
    end

    @playlist.tags_attributes = tags_attributes

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

  def search_editors
    @search = params[:search]
    not_in = @playlist.editors.ids
    not_in << current_user.id

    if (@search)
      search_query = "%#{@search}%"
      @users = User.where("username LIKE ? OR email LIKE ? AND id NOT IN (?)", search_query, search_query, not_in)
    else
      @users = User.where("id NOT IN (?)", not_in)
    end
  end

  def add_editor
    editor = User.find(params[:user])
    notification = Notification.new(
      message: "<a href='/playlists/#{@playlist.id}'>You've been invited to edit #{@playlist.title}</a>",
      sender_id: current_user.id,
      recipient_id: editor.id,
      read: false
    )

    begin
      @playlist.editors.push(editor)
    rescue Exception => e
      redirect_to add_editor_path(@playlist), notice: 'Could not add user'
    else
      notification.save
      redirect_to playlist_path(@playlist), notice: "Editor was successfully added."
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

  # Use callbacks to share common setup or constraints between actions.
  def set_playlist
    @playlist = Playlist.find(params[:id])
  end

  # Protect playlists from unauthorized users
  def correct_user
    @is_user = current_user.id === @playlist.user_id
    unless @is_user
        redirect_to user_account_path(current_user)
    end
  end
  
  def correct_editor
    @is_editor = current_user && @playlist.editors.ids.include?(current_user.id)
  end

  private

    # Only allow a list of trusted parameters through.
    def playlist_params
      params.require(:playlist).permit(:title, :image, :tags_attributes => [:label])
    end
end
