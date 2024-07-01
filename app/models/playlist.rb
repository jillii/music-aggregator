class Playlist < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
end
