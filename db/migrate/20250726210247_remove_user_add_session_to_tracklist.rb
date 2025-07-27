class RemoveUserAddSessionToTracklist < ActiveRecord::Migration[7.0]
  def change
    remove_column :tracklists, :user, :reference
    add_column :tracklists, :session, :string
  end
end
