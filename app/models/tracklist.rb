class Tracklist < ApplicationRecord
  has_many :tracks, dependent: :nullify
  validates :session, presence: true, uniqueness: true
end
