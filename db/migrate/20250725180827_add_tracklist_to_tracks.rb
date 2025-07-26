class AddTracklistToTracks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tracks, :tracklist, foreign_key: true
  end
end
