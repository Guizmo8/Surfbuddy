class Post < ApplicationRecord
  belongs_to :surfspot
  has_many :alerts

  delegate :favourites, to: :surfspot

  validates :ripple, presence: true

  after_create :post_surf_level
  after_create :create_alert

  def content
    if super.blank?
      set_content
    else
      super
    end
  end

  def set_content
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-4o",
      messages: [{ role: "user", content: "In 100 characters or less summarise the surfing conditions considering #{self.surfspot.location} #{tide} #{ripple} #{wave_period} #{wave_direction} #{wind} #{wind_direction} #{sea_temperature} without being specific about data, and suggesting level of experience required based on #{self.post_surf_level}."}]
    })
    new_content =  chatgpt_response["choices"][0]["message"]["content"]

    update(content: new_content)
    return new_content
  end

  private

  def post_surf_level
    ripple = self.ripple.chop.to_f
    puts ripple
    if ripple <= 1.0
      update!(surf_level: "Beginner")
    elsif ripple <= 2.0
      update!(surf_level: "Intermediate")
    else
      update!(surf_level: "Advanced")
    end
  end

  def create_alert
    # We grab the favourites with alerts ON that belong to the surfspot of the post that has being created
    # Then we iterate over it
    favourites.with_alerts.each do |favourite| # How is is a grabbing each post?
      # For each instance, we skip the favourites where the post's surf level does not match the user's surf level
      next if favourite.user_surf_level != surf_level

      # skip if favourite.user.wants_alerts_now?

      # If the surf level matches, we create an alert
      Alert.create!(user: favourite.user, favourite:, post: self)
    end
  end
end
