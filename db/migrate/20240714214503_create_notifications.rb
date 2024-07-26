class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.text :message
      t.references :recipient, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: true
      t.boolean :read

      t.timestamps
    end
  end
end
