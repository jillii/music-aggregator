class TagsController < ApplicationController
  # GET /playlist/:id/update
  def new
    @tag = Tag.new
  end

  # POST /playlist/:id/update
  def create
    @tag = Tag.new(tag_params)
    @tag.playlist_id = params[:id]

    respond_to do |format|
      if @tag.save
        format.html { redirect_to playlist_path(@tag), notice: "Playlist was successfully created." }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1 or /playlists/1.json
  def destroy
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to playlists_url, notice: "Tag was successfully removed." }
      format.json { head :no_content }
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def tag_params
      params.require(:tag).permit(:label)
    end
end
