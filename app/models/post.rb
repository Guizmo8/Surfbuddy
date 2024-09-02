class Post < ApplicationRecord
  belongs_to :surfspot

  validates :ripple, presence: true

  after_create_commit :post_surf_level

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
    elsif ripple > 2.0
      update!(surf_level: "Advanced")
    elsif ripple <= 2.0
      update!(surf_level: "Intermediate")
    end
  end


end
