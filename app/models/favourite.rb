class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :surfspot

  has_many :alerts
  has_many :posts, through: :surfspot

  validates :surfspot_id, uniqueness: { scope: :user_id }
end
