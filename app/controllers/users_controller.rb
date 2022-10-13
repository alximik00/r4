class UsersController < ApplicationController
  def create
    if data = Loginza.user_data(permitted_params)
      @user = User.find_or_create(data)
      redirect_to root_path
    else
      redirect_to login_path
    end
  end

  def permitted_params
    params.permit(:email, :password, :password_confirmation, :remember_me)
  end
end
