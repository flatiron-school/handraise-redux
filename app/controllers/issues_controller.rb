class IssuesController < ApplicationController
  skip_before_filter :login_required, :only => "theme"

  # GET /issues
  # GET /issues.json
  def index   
    @issues = Issue.all
    @closed_issues = Issue.closed
    @fellow_student_issues = Issue.fellow_student
    @instructor_normal_issues = Issue.instructor_normal
    @instructor_urgent_issues = Issue.instructor_urgent
    @assigned_issues = Issue.assigned
    @assignable_issues = Issue.issues_assignable
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @issue = Issue.find(params[:id])
    @user_login_name = @issue.user.identities.first.login_name if @issue.gist_id
    @response = @issue.responses.build

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issue }
    end
  end

  # GET /issues/new
  # GET /issues/new.json
  def new
    if current_user.has_open_issue?
      redirect_to issues_path, :notice => "Please close your open issue '#{view_context.link_to(@current_user.issues.not_closed.first.title, issue_path(@current_user.issues.not_closed.first))}' first"
    else
      @issue = Issue.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @issue }
      end
    end
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(params[:issue])
    @issue.to_fellow_student
    @issue.user_id = session[:user_id]

    new_gist = params[:issue]["relevant_gist"]
    unless new_gist == "" || new_gist.nil?
      @issue.send_to_github(new_gist, @current_user)
    end

    respond_to do |format|
      if @issue.save
        format.html { redirect_to issues_path, notice: 'Issue was successfully created.' }
        format.json { render json: @issue, status: :created, location: @issue }
      else
        format.html { render action: "new" }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end

  end

  # GET /issues/1/edit
  def edit
    @issue = Issue.find(params[:id])

    if current_user.can_edit?(@issue)
      respond_to do |format|
        format.html
        format.json { render json: @issue}
      end
    else
      redirect_to issues_path, :notice => "You are not authorized to edit this issue"
    end
  end

  # PUT /issues/1
  # PUT /issues/1.json
  def update
    @issue = Issue.find(params[:id])    
    if @issue.gist_id.nil?
      @issue.update_attributes(params[:issue])
    elsif @issue.gist_id
      @gist = params[:issue]["relevant_gist"]
      @issue.relevant_gist = @gist
      @issue.edit_github_gist(@gist, @current_user)
    else
      new_gist = params[:issue]["relevant_gist"]
      @issue.send_to_github(new_gist, @current_user) if new_gist != ""
      @issue.relevant_gist = new_gist
    end
    @issue.save

    redirect_to issue_path(@issue)
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue = Issue.find(params[:id])
    if current_user.can_destroy?(@issue)
      @issue.destroy
      respond_to do |format|
        format.html { redirect_to issues_path, notice: "Issue was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to issue_path(@issue), :notice => "You are not authorized to destroy this issue"
    end
  end

  def resolve
    @issue = Issue.find(params[:id])
    if @current_user.can_resolve?(@issue)
      @issue.to_closed
      @issue.save
      redirect_to issues_path
    else
      redirect_to issues_path, :notice => "You are not allowed to mark this issue as resolved"
    end
  end

  def helped
    @issue = Issue.find(params[:id])
    if @current_user.can_mark_as_helped?(@issue)
      @issue.to_post_help
      @issue.assignee_id = nil
      @issue.save
      redirect_to issues_path
    else
      redirect_to issues_path, :notice => "You are not allowed to mark this issue as post help"
    end
  end

  def unhelp
    @issue = Issue.find(params[:id])
    if @current_user.owns?(@issue)
      @issue.status_change
      @issue.save
      redirect_to user_path(@current_user)
    else
      redirect_to issues_path, :notice => "You are not allowed to mark this issue as post unhelped"
    end
  end

  def assign
    @issue = Issue.find(params[:id])
    if @current_user.can_assign?(@issue)
      twilio_client = TwilioWrapper.new
      @issue.assignee_id = session[:user_id]
      @issue.save
      twilio_client.create_sms(@issue,'assign') if @issue.user.has_cell?
      redirect_to issues_path
    else
      redirect_to issues_path, :notice => "You are not allowed to assign yourself to this issue"
    end
  end

  def unassign
    @issue = Issue.find(params[:id])
    if @current_user.can_unassign?(@issue)
      twilio_client = TwilioWrapper.new
      twilio_client.create_sms(@issue,'unassign') if @issue.user.has_cell?
      @issue.assignee_id = nil
      @issue.save
      redirect_to issues_path
    else
      redirect_to issues_path, :notice => "You are not allowed to unassign someone from this issue"
    end
  end

  def big_board
    @assigned_issues = Issue.assigned
    @instructor_normal_issues = Issue.instructor_normal
    @instructor_urgent_issues = Issue.instructor_urgent
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end

  def voteup
    @issue = Issue.find(params[:id])
    if @current_user.can_upvote?(@issue)
      vote = @issue.votes.create
      vote.user = current_user
      vote.save
      redirect_to issues_path
    else
      redirect_to issues_path, :notice => "Don't be sneaky, no one likes a cheater!"
    end
  end

  def votedown
    @issue = Issue.find(params[:id])
    if @current_user.can_votedown?(@issue)
      vote = Vote.where(:user_id => current_user.id, :issue_id => @issue.id).first
      vote.delete
      redirect_to issues_path
    else
      redirect_to issues_path, :notice => "Hey #{@current_user.name}, #{@issue.user.name} says don't be a dick!"
    end    
  end

end
