class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    @user = User.authenticate(params[:email], params[:password])
    if @user
      session[:user_id] = @user.id
      redirect_to issues_path, :notice => "Logged in!"
    else
      redirect_to login_path, :notice => "Invalid email or password"
    end
  end

  def destroy
    
  end

end