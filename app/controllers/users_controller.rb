class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_session(@user) # signs in the user
      # session[:user_id] = @user.id    # same as above
      flash[:notice] = "User was saved successfully!"
      redirect_to root_url
    else
      flash[:error] = "There was an error saving. Please try again."
      render :new
    end
  end

  def confirm
    @user = User.new(user_params)
  end

  def edit
  #  @user = User.find(params[:id])
  end

  def update
  #  @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "You have updated your user account."
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "There was a problem updating your account. Please try again."
      render :edit
    end
  end

  def destroy
  #  @user = User.find(params[:id])
    @user.destroy
    destroy_session(current_user) # session[:user_id] = nil
    flash[:notice] = "User is now deleted."
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
