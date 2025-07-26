class CreateTracklists < ActiveRecord::Migration[7.0]
  def change
    create_table :tracklists do |t|
      t.string :link
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
