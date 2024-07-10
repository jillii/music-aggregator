class AddPlaylistToTags < ActiveRecord::Migration[7.0]
  def change
    add_reference :tags, :playlist, foreign_key: true
  end
end
