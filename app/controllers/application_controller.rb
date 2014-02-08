class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :login_required

  private
      
  def reset_stats
    redirect_to issue_stats_reset_stats_path
  end

  def login_required
    redirect_to(login_path, :notice => "Please login") if !logged_in?
  end

  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
