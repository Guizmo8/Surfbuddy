class AlertsController < ApplicationController
  def index
    @user = current_user
    @alerts = Alert.where(user: @user)
  end
  
end
