class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :favourite

  validate :favourite_must_have_alerts_on

  PHONE_NUMBER = "+16314497230"

  def index
    @alerts = Alert.all
    
  end

  private

  def favourite_must_have_alerts_on
    unless favourite.alert
      errors.add(:favourite, 'must have alerts enabled')
    end
  end
end
