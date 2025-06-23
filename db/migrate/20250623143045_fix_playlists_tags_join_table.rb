class FixPlaylistsTagsJoinTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :playlists_tags

    create_table :playlist_tags do |t|
      t.references :playlist, null: false, foreign_key: true
      t.references :tag,      null: false, foreign_key: true
      t.timestamps
    end
    add_index :playlist_tags, [:playlist_id, :tag_id], unique: true
  end
end