class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :favourite
  belongs_to :post

  validate :favourite_must_have_alerts_on
  after_create :send_alert

  # TWILIO_ACCOUNT_SID = ENV.fetch('TWILIO_ACCOUNT_SID')
  # TWILIO_TOKEN = ENV.fetch("TWILIO_TOKEN")
  PHONE_NUMBER = "+16314497230"

  private

  def send_alert
    return unless Rails.env == "production"
    
    return unless user.phone_number == "+33665151713"

    client = Twilio::REST::Client.new(ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_TOKEN'))

    client.messages.create(
      from: Alert::PHONE_NUMBER,
      to: user.phone_number, # Replace with the user phone number
      body: "#{post.surfspot.name} - #{post.content}" # Content of the sms sent = alerts
    )
  end

  def favourite_must_have_alerts_on
    return if favourite.alert

    errors.add(:favourite, 'must have alerts enabled')
  end
end
