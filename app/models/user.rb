class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  has_many :playlists, dependent: :destroy
  has_and_belongs_to_many :playlists_editing, 
                          class_name: 'Playlist', 
                          join_table: :editors_playlists, 
                          foreign_key: :user_id
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'sender_id'
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'recipient_id'

  has_many :likes, dependent: :destroy
  has_many :liked_playlists, through: :likes, source: :playlist

  paginates_per 20

  has_many :follower_relationships, class_name: 'Follow', foreign_key: 'followed_id'
  has_many :followers, through: :follower_relationships, source: :follower
  
  has_many :following_relationships, class_name: 'Follow', foreign_key: 'follower_id'
  has_many :following, through: :following_relationships, source: :followed
end
