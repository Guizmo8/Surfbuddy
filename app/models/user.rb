class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favourites, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :surfspots, through: :favourites, dependent: :destroy

  attr_accessor :confidence_level, :wave_size, :maneuver_skill, :board_type, :ocean_knowledge

  def wants_alert_now?
    current_time = Time.zone.now.strftime("%H:%M")
    start_time = alert_start_time.strftime("%H:%M")
    end_time = alert_end_time.strftime("%H:%M")

    current_time >= start_time && current_time <= end_time
  end
end
