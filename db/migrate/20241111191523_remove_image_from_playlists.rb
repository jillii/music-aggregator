class RemoveImageFromPlaylists < ActiveRecord::Migration[7.0]
  def change
    remove_column :playlists, :image, :attachment
  end
end
