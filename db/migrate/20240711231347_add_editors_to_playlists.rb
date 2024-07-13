class AddEditorsToPlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :editors_playlists do |t|
      t.references :playlists, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
    end

    add_index :editors_playlists, [:playlist_id, :user_id], unique: true
  end
end
