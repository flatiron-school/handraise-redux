class SessionsController < ApplicationController
  skip_before_filter :login_required, :except => "destroy"

  def new
  end

  def new_github
  end

  def github
    raise response.inspect
    github_code = params[:code]
    github_path = "https://github.com/login/oauth/#{github_code}"
    # raise HTTParty.post(github_path).inspect
  end
  
  def create
    raise params.inspect
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to issues_path, :notice => "Logged in!"
    else
      redirect_to login_path, :notice => "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, :notice => "Logged out!"
  end

end