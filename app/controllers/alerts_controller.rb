class AlertsController < ApplicationController
  def index
    @user = current_user
    @alerts = Alert.where(user: current_user)
    @posts = current_user.alert_posts
  end

end
