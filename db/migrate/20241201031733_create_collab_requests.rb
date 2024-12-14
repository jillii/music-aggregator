class CreateCollabRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :collab_requests do |t|
      t.integer :sender_id
      t.integer :reciever_id

      t.timestamps
    end
    add_index :collab_requests, :sender_id
    add_index :collab_requests, :reciever_id
    add_index :collab_requests, [:sender_id, :reciever_id], unique: true
  end
end
