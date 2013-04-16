class ResponsesController < ApplicationController

  def new
    @response = Response.new
  end

  def create
    @response = Response.new(params[:response])
    @response.user_id = session[:user_id]
    @response.issue_id = params[:issue][:id]
    @response.save
    twilio_client = TwilioWrapper.new
    twilio_client.create_sms(@response.issue,'response') if @response.issue.user.has_cell?
    redirect_to issue_path(@response.issue)
  end

  def answer
    @response = Response.find_by_id(params[:response_id])
    @response.toggle_answer
    @response.save

    if @response.answer == nil
      twilio_client = TwilioWrapper.new
      twilio_client.create_sms(@response,'unanswer') if @response.user.has_cell?
    else
      twilio_client = TwilioWrapper.new
      twilio_client.create_sms(@response,'answer') if @response.user.has_cell?
    end

    @issue = @response.issue
    if @issue.closed? 
      @issue.status_change 
    else
      @issue.to_closed
    end
    @issue.save

    redirect_to issue_path(@response.issue)
  end

end
