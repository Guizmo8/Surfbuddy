class Surfspot < ApplicationRecord
  has_many :favourites
  has_many :posts, dependent: :destroy
end
