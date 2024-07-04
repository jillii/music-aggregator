class RemoveTracklistFromPlaylists < ActiveRecord::Migration[7.0]
  def change
    remove_column :playlists, :tracklist
  end
end
