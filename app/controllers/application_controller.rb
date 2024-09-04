class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :surf_level, :phone_number, :alert_start_time, :alert_end_time, :confidence_level, :wave_size, :maneuver_skill, :board_type, :ocean_knowledge])
  end
end
