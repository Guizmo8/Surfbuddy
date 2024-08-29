class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :favourite

  validate :favourite_must_have_alerts_on

  private

  def favourite_must_have_alerts_on
    unless favourite.alert
      errors.add(:favourite, 'must have alerts enabled')
    end
  end
end
