class AlertsController < ApplicationController
  def index
    @user = current_user
    @alerts = Alert.where(user: current_user)
    @user.update(check_alerts_at: Time.zone.now)
  end
end
