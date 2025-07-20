class Playlist < ApplicationRecord
  belongs_to :user, class_name: 'User'
  has_and_belongs_to_many :editors, 
                          class_name: 'User', 
                          join_table: :editors_playlists, 
                          association_foreign_key: :user_id
  has_many :tracks, -> { order(order: :asc) }, dependent: :destroy
  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :tags
  validates :title, presence: true
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  paginates_per 18

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  has_many :collab_requests

  scope :popular, -> {
    order("likes_count DESC")
  }
  validate :image_size_validation

  private

  def image_size_validation
    if image.attached? && image.blob.byte_size > 1.megabytes
      errors.add(:image, "should be less than 1MB")
    end
  end
end
