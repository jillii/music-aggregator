class RemovePlaylistsTagsTimestamps < ActiveRecord::Migration[7.0]
  def change
    remove_column :playlists_tags, :created_at if column_exists?(:playlists_tags, :created_at)
    remove_column :playlists_tags, :updated_at if column_exists?(:playlists_tags, :updated_at)
  end
end
