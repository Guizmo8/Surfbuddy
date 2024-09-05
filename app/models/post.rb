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
    begin
      client = OpenAI::Client.new
      chatgpt_response = client.chat(parameters: {
        model: "gpt-4o",
        messages: [{ role: "user", content: "In 140 characters or less explain how the following #{surfspot.location} #{tide} #{ripple} #{wave_period} #{wave_direction} #{wind} #{wind_direction} #{sea_temperature} conditions shape the surfing experience without using numbers."}]
      })

      new_content =  chatgpt_response["choices"][0]["message"]["content"]
      update(content: new_content)

      return new_content
    rescue Faraday::TooManyRequestsError => e
      puts e
    end
  end

  def post_surf_level
    ripple_height = ripple.chop.to_f
    wind = self.wind.chop.to_f
    wave_period = self.wave_period.chop.to_f
    sea_temp = sea_temperature.chop.to_f

    tide_str = tide.gsub('h', '')
    tide_time = Time.strptime(tide_str, "%H.%M").strftime('%H%M').to_i

    factors = [wind_factor(wind), ripple_factor(ripple_height), wave_period_factor(wave_period), sea_temp_factor(sea_temp),
               tide_factor(tide_time)]

    level = factors.group_by(&:itself).values.max_by(&:size).first

    update!(surf_level: level)
  end

  private

  def wind_factor(wind)
    case wind
    when 0..16
      "Beginner"
    when 17..24
      "Intermediate"
    else
      "Advanced"
    end
  end

  def ripple_factor(ripple_height)
    case ripple_height
    when 0..1.0
      "Beginner"
    when 1.1..2.0
      "Intermediate"
    else
      "Advanced"
    end
  end

  def wave_period_factor(wave_period)
    case wave_period
    when 0..8
      "Beginner"
    when 8.1..12
      "Intermediate"
    else
      "Advanced"
    end
  end

  def sea_temp_factor(sea_temp)
    case sea_temp
    when 20..25
      "Beginner"
    when 15..19
      "Intermediate"
    else
      "Advanced"
    end
  end

  def tide_factor(tide_time)
    case tide_time
    when 500..800
      "Beginner"
    when 800..1600
      "Intermediate"
    else
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
