class VotesController < ApplicationController
  def new
    @vote = Vote.new
  end

  def create
    @vote = Vote.new
    @vote.issue_id = params[:issue][:id]
    @vote.user_id = session[:user_id]
    @vote.save

    redirect_to issue_path(@vote.issue)
  end
end
