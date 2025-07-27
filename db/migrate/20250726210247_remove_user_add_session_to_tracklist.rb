class RemoveUserAddSessionToTracklist < ActiveRecord::Migration[7.0]
  def change
    add_column :tracklists, :session, :string
  end
end
