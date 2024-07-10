class TagsController < ApplicationController
  # DELETE /playlists/1 or /playlists/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: "Tag was successfully removed." }
      format.json { head :no_content }
    end
  end
end
