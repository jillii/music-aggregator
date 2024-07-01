class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists do |t|
      t.string :title
      t.string :image
      t.text :tracklist
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
