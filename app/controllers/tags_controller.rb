class TagsController < ApplicationController
  # DELETE /playlists/1 or /playlists/1.json
  def destroy
    playlist = Playlist.find(params[:playlist_id])
    tag = Tag.find(params[:id])

    playlist.tags.delete(tag)
    tag.destroy if tag.playlist_ids.empty?

    respond_to do |format|
      if playlist.save
        format.html { redirect_to request.referrer, notice: "Tag was successfully removed." }
        format.json { head :no_content }
      end
    end
  end
end
