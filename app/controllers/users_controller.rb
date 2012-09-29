class UsersController < ApplicationController
  def create
    if data = Loginza.user_data(params[:token])
      @user = User.find_or_create(data)
      redirect_to root_path
    else
      redirect_to login_path
    end
  end
end
