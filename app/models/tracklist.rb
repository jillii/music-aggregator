class Tracklist < ApplicationRecord
  belongs_to :user
  has_many :tracks, dependent: :nullify
end
