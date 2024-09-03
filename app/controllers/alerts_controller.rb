class AlertsController < ApplicationController
  def index
    @user = current_user
    @alerts = Alert.where(user: current_user)
  end

end
