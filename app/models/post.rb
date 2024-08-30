class Post < ApplicationRecord
  belongs_to :surfspot

  validates :ripple, presence: true

  after_create_commit :post_surf_level

  private

  def post_surf_level
    ripple = self.ripple.chop.to_f
    puts ripple
    if ripple <= 1.0
      update!(surf_level: "Beginner")
    elsif ripple > 2.0
      update!(surf_level: "Advanced")
    elsif ripple <= 2.0
      update!(surf_level: "Intermediate")
    end
  end
end
