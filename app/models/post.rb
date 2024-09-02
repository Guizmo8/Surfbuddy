class Post < ApplicationRecord
  belongs_to :surfspot

  delegate :favourites, to: :surfspot

  validates :ripple, presence: true

  after_create :post_surf_level
  after_create :create_alert

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

  def create_alert
    # We grab the favourites with alerts ON that belong to the surfspot of the post that has being created
    # Then we iterate over it
    favourites.with_alerts.each do |favourite|
      # For each instance, we skip the favourites where the post's surf level does not match the user's surf level
      next if favourite.user_surf_level != surf_level

      # skip if favourite.user.wants_alerts_now?

      # If the surf level matches, we create an alert
      Alert.create!(user: favourite.user, favourite:)
    end
  end
end
