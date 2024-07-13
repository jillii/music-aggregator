class Playlist < ApplicationRecord
  belongs_to :user, class_name: 'User'
  has_and_belongs_to_many :editors, 
                          class_name: 'User', 
                          join_table: :editors_playlists, 
                          association_foreign_key: :user_id
  has_many :tracks, -> { order(order: :asc) }, dependent: :destroy
  has_many :tags
  accepts_nested_attributes_for :tags
  validates :title, presence: true
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  paginates_per 3
end
