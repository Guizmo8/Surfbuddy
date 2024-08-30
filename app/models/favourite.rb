class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :surfspot

  has_many :alerts, dependent: :destroy
  has_many :posts, through: :surfspot

  validates :surfspot_id, uniqueness: { scope: :user_id }

  def set_alert
    if self.alert == false
      self.update!(alert: true)
    else
      self.update!(alert: false)
    end
  end
end
