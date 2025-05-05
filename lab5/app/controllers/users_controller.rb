class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to books_path, notice: "User successfully created!"
    else
      render :new
    end
  end

  def destroy
    if current_user.authenticate(params[:password])
      current_user.destroy
      reset_session
      redirect_to login_path, notice: "User deleted!"
    else
      redirect_to books_path, alert: "Incorrect password"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
