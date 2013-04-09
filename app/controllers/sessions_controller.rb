class SessionsController < ApplicationController
  skip_before_filter :login_required, :except => "destroy"

  def new
    render :layout => 'fullwidth'
  end

  def new_github
  end

  def github
    auth = request.env['omniauth.auth']
    unless @auth = Identity.find_from_hash(auth)
      # create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Identity.create_from_hash(auth, current_user)
    end

    # Log the authorizing user in.
    current_user = @auth.user
    redirect_to new_issue_path, :notice => "Welcome, #{current_user.name}."
  end
  
  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      if @user.admin?
        redirect_to issues_path, :notice => "Logged in!" 
      else
        redirect_to user_path(@user), :notice => "Logged in!"  
      end
    else
      redirect_to login_path, :notice => "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, :notice => "Logged out!"
  end

end