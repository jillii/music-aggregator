class AddPlaylistToCollabRequests < ActiveRecord::Migration[7.0]
  def change
    add_reference :collab_requests, :playlist, foreign_key: true
  end
end
