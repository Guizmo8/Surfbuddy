class Surfspot < ApplicationRecord
  has_many :favourites
  has_many :posts, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :super_search,
  against: [ :location , :name],
  using: {
    tsearch: { prefix: true }
  }
end
