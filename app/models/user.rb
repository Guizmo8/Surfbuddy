class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favourites, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :surfspots, through: :favourites, dependent: :destroy

  def wants_alert_now?
    current_time = Time.zone.now.strftime("%H:%M")

    # Return false if either start_time or end_time is nil. The opposite of a falsy value is true
    return false if !alert_start_time || !alert_end_time

    start_time = alert_start_time.strftime("%H:%M")
    end_time = alert_end_time.strftime("%H:%M")

    current_time >= start_time && current_time <= end_time
  end
end
