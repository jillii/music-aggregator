class RenamePlaylistsIdToPlaylistIdInEditorsPlaylists < ActiveRecord::Migration[7.0]
  def change
    rename_column :editors_playlists, :playlists_id, :playlist_id
  end
end
