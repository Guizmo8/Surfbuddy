class UsersController < Devise::RegistrationsController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)

    @user.surf_level = determine_surf_level(
      params[:user][:confidence_level],
      params[:user][:wave_size],
      params[:user][:maneuver_skill],
      params[:user][:board_type],
      params[:user][:ocean_knowledge]
    )

    if @user.save
      sign_in(@user)
      redirect_to root_path, notice: "Welcome Surf Buddy!"
    else
      render :new
    end

  end

  private

  def user_params
    params.require(:user).permit(
                          :first_name,
                          :last_name,
                          :surf_level,
                          :password,
                          :password_confirmation,
                          :email,
                          :phone_number,
                          :alert_start_time,
                          :alert_end_time,
                          :confidence_level,
                          :wave_size,
                          :maneuver_skill,
                          :board_type,
                          :ocean_knowledge
                        )
  end

  def determine_surf_level(confidence_level, wave_size, maneuver_skill, board_type, ocean_knowledge)
    levels = [confidence_level, wave_size, maneuver_skill, board_type, ocean_knowledge]

    advanced_count = levels.count('C')
    intermediate_count = levels.count('B')

    if advanced_count >= 3
      'Advanced'
    elsif intermediate_count >= 3
      'Intermediate'
    else
      'Beginner'
    end
  end
end
