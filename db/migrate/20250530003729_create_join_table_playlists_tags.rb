class CreateJoinTablePlaylistsTags < ActiveRecord::Migration[7.0]
  def change
    create_join_table :playlists, :tags do |t|
      t.index [:playlist_id, :tag_id]
      t.index [:tag_id, :playlist_id]
    end
  end
end
