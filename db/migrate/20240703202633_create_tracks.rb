class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :track_id
      t.string :title
      t.string :source
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
