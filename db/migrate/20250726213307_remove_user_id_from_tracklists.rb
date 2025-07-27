class RemoveUserIdFromTracklists < ActiveRecord::Migration[7.0]
  def change
    remove_column :tracklists, :user_id, :integer
  end
end
