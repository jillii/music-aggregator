class Playlist < ApplicationRecord
  belongs_to :user
  has_many :tracks, dependent: :destroy
  validates :title, presence: true
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
end
