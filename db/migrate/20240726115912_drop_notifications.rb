class DropNotifications < ActiveRecord::Migration[7.0]
  def change
    if table_exists?(:notifications)
      drop_table :notifications
    end
  end
end
