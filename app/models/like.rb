class Like < ApplicationRecord
  belongs_to :user
  belongs_to :playlist, counter_cache: true

  validates :user_id, uniqueness: { scope: :playlist_id }
end
