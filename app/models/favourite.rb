class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :surfspot

  has_many :alerts, dependent: :destroy
  has_many :posts, through: :surfspot, dependent: :destroy
end
