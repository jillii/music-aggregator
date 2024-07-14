class AddAddedByToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :addedby, :integer
  end
end
