class ResponsesController < ApplicationController

  def new
    @response = Response.new
  end

  def create
    @response = Response.new(params[:response])
    @response.user_id = session[:user_id]
    @response.issue_id = params[:issue][:id]
    @response.save

    redirect_to issue_path(@response.issue)
  end

  def answer
    @response = Response.find_by_id(params[:response_id])
    @response.toggle_answer
    @response.save

    redirect_to issue_path(@response.issue)
  end

end
