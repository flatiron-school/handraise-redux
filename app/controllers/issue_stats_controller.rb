class IssueStatsController < ApplicationController
  def new
    @issue_stat = IssueStat.new
  end

  def create
    @issue_stat = IssueStat.new(params[:issue_stat])
    @issue_stat.save
  end

  def update
    @issue_stat = IssueStat.find(params[:id])
    @issue_stat.update_attributes(params[:issue_stat])
  end

  def destroy
    @issue_stat = IssueStat.find(params[:id])
    @issue.destroy
  end

  def reset_stats
    IssueStat.reset_stats

    redirect_to issues_path
  end

end
