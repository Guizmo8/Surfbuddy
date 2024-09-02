class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :surfspot

  delegate :surf_level, to: :user, prefix: true
  scope :with_alerts, -> { where(alert: true) }

  has_many :alerts, dependent: :destroy
  has_many :posts, through: :surfspot

  validates :surfspot_id, uniqueness: { scope: :user_id }

  def set_alert
    if alert == false
      update!(alert: true)
    else
      update!(alert: false)
    end
  end
end
