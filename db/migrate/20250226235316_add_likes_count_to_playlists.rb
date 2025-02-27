class AddLikesCountToPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :likes_count, :integer, default: 0
  end
end
