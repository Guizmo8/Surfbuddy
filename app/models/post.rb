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
      messages: [{ role: "user", content: "In 100 characters or less summarise the surfing conditions considering #{self.surfspot.location} #{tide} #{ripple} #{wave_period} #{wave_direction} #{wind} #{wind_direction} #{sea_temperature} without using numbers, and recommending experience level based on #{self.post_surf_level}"}]
    })
    new_content =  chatgpt_response["choices"][0]["message"]["content"]

    update(content: new_content)
    return new_content
  end

  def post_surf_level
    ripple_height = self.ripple.chop.to_f
    wind_speed = self.wind.chop.to_f
    wave_period = self.wave_period.chop.to_f
    sea_temp = self.sea_temperature.chop.to_f
    tide_time = self.tide.strftime('%H%M').to_i

    wind_factor = case wind_speed
    when 0..16
      "Beginner"
    when 17..24
      "Intermediate"
    else
      "Advanced"
    end

    ripple_factor = case ripple_height
    when 0..1.0
      "Beginner"
    when 1.1..2.0
      "Intermediate"
    else
      "Advanced"
    end

    wave_period_factor = case wave_period
    when 0..8
      "Beginner"
    when 8.1..12
      "Intermediate"
    else
      "Advanced"
    end

    sea_temp_factor = case sea_temp
    when 20..25
      "Beginner"
    when 15..19
      "Intermediate"
    else
      "Advanced"
    end

    tide_factor = case tide_time
    when 500..800
      "Beginner"
    when 800..1600
      "Intermediate"
    when 1600..2000
      "Advanced"
    else
      "Advanced"
    end


    wind_direction_factor = determine_wind_direction_factor(self.wind_direction, self.wave_direction)

    factors = [wind_factor, ripple_factor, wave_period_factor, sea_temp_factor, tide_factor,  wind_direction_factor]

    level = factors.group_by(&:itself).values.max_by(&:size).first

    update!(surf_level: level)

  end


  private

  def determine_wind_direction_factor(wind_direction, wave_direction)
    # Simple mapping of directions to angles
    directions_to_angle = {
      "North" => 0, "North-east" => 45, "East" => 90, "South-east" => 135,
      "South" => 180, "South-west" => 225, "West" => 270, "North-west" => 315
    }

    wind_angle = directions_to_angle[wind_direction]
    wave_angle = directions_to_angle[wave_direction]

    # Calculate the difference in angles
    angle_diff = (wind_angle - wave_angle).abs % 360
    angle_diff = 360 - angle_diff if angle_diff > 180

    # Determine the wind direction factor
    case angle_diff
    when 0 # Onshore
      "Beginner"
    when 1..90 # Cross-shore
      "Intermediate"
    else # Offshore
      "Advanced"
    end
  end

  def create_alert
    # We grab the favourites with alerts ON that belong to the surfspot of the post that has being created
    # Then we iterate over it
    favourites.with_alerts.each do |favourite| # How is is a grabbing each post?
      # For each instance, we skip the favourites where the post's surf level does not match the user's surf level
      next if favourite.user_surf_level != surf_level

      next unless favourite.user.wants_alert_now?

      # If the surf level matches, we create an alert
      Alert.create!(user: favourite.user, favourite:, post: self)
    end
  end
end
