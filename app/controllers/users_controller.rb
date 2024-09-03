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

  private

  def user_params
    params.require(:user).permit(:first_name,
                                 :last_name,
                                 :surf_level,
                                 :phone_number,
                                 :email,
                                 :alert_start_time,
                                 :alert_end_time)
  end
end
