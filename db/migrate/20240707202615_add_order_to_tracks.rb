class AddOrderToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :order, :integer
  end
end
