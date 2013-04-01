class IssuesController < ApplicationController
  skip_before_filter :login_required, :only => "theme"

  # GET /issues
  # GET /issues.json
  def index   
    @issues = Issue.all
    @closed_issues = Issue.closed
    @waiting_room_issues = Issue.waiting_room(current_user.id)
    @fellow_student_issues = Issue.fellow_student
    @instructor_normal_issues = Issue.instructor_normal
    @instructor_urgent_issues = Issue.instructor_urgent
    @assigned_issues = Issue.assigned

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
    @issue = Issue.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issue }
    end
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = Issue.new(params[:issue])
    @issue.status = 1
    @issue.user_id = session[:user_id]

    new_gist = params[:issue]["relevant_gist"]
    @issue.send_to_github(new_gist, @current_user) if new_gist != ""

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

    if @issue.user_id == session[:user_id] || @current_user.role == 0
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
    if @issue.gist_id
      @gist = params[:issue]["relevant_gist"]
      @issue.relevant_gist = @gist
      @issue.edit_github_gist(@gist, @current_user)
    else
      @new_gist = params[:issue]["relevant_gist"]
      @issue.send_to_github(new_gist, @current_user) if new_gist != ""
      @issue.relevant_gist = @new_gist
    end
    @issue.save

    redirect_to issue_path(@issue)

    # respond_to do |format|
    #   if @issue.update_attributes(params[:issue])
    #     unless @issue.assignee.nil?
    #       @issue.status = 3 
    #       @issue.save
    #     end
    #     format.html { redirect_to issues_path, notice: 'Issue was successfully updated.' }
    #     format.json { head :no_content }
    #   else
    #     format.html { render action: "edit" }
    #     format.json { render json: @issue.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to issues_path, notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def resolve
    @issue = Issue.find(params[:id])
    @issue.status = Issue::STATUS_MAP[:closed]
    @issue.save

    redirect_to issues_path
  end

  def assign
    twilio_client = TwilioWrapper.new

    @issue = Issue.find(params[:id])
    @issue.assignee_id = session[:user_id]
    @issue.save

    twilio_client.create_sms(@issue,'assign')

    redirect_to issues_path
  end

  def unassign
    twilio_client = TwilioWrapper.new

    @issue = Issue.find(params[:id])

    twilio_client.create_sms(@issue,'unassign')

    @issue.assignee_id = nil
    @issue.save

    

    redirect_to issues_path
  end

  def big_board
    @instructor_normal_issues = Issue.instructor_normal
    @instructor_urgent_issues = Issue.instructor_urgent
    # binding.pry
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issues }
    end
  end

  def theme
    @issues = Issue.all
  end

  def voteup
    @issue = Issue.find(params[:id])
    vote = @issue.votes.create
    vote.user = current_user
    vote.save

    redirect_to issues_path
  end

  def votedown
    @issue = Issue.find(params[:id])
    vote = Vote.where(:user_id => current_user.id, :issue_id => @issue.id).first
    vote.delete

    redirect_to issues_path
  end

end
