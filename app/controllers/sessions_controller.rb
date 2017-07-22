class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      create_session(user) # session[:user_id] = user.id
      #session[:user_id] = user.id
      flash[:notice] = "Welcome, #{user.name}!"
      redirect_to root_path
    else
      flash.now[:alert] = 'Invalid email/password combination'
      render :new
    end
  end

  def destroy
    #session[:user_id] = nil
    # user = User.find(params[:id])
    # user = User.find_by(id: params[:user_id])
    # destroy_session(user)
    destroy_session(current_user)
    flash[:notice] = "You've been signed out, come back soon!"
    redirect_to root_path
  end

  # can't use strong params here because sessions does not have a model

end
