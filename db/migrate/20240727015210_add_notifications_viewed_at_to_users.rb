class AddNotificationsViewedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notifications_viewed_at, :datetime
  end
end
