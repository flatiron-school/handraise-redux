class UsersController < ApplicationController
  skip_before_filter :login_required, :only => ["new", "create"]

  # GET /users
  # GET /users.json
  def index
    @users = User.find(:all, :order => "name")

    if @current_user.admin?
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    else
      redirect_to issues_path, :notice => "Sorry, only admins have access to users index."      
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.includes(:issues).find(params[:id])
      @open_issue = @user.issues.not_closed
      @closed_issues = @user.issues.closed
      @user_login_name = @user.identities.first.login_name if @user.identities.first
    render :layout => 'dashboard'
  end

  # GET /users/new
  # GET /users/new.json
  def new
    # raise params.inspect
    @user = User.new
    respond_to do |format|
      format.html {render :layout => 'fullwidth'}
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    if @current_user.can_edit_delete_profile?(@user)
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @user }
      end
    else
      redirect_to issues_path, :notice => "You are not authorized to edit this user profile"
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.cell = @user.cell.gsub("-","").gsub(".","").gsub("(","").gsub(")","").gsub(" ","")
    @user.set_as_student

    if @user.save
      redirect_to user_path(@user)
    else
      render :action => "new", :layout => "fullwidth"
    end
    # respond_to do |format|
    #   if @user.save
    #     session[:user_id] = @user.id
    #     format.html { redirect_to user_path(@user), notice: 'User was successfully created and logged in' }
    #     format.json { render json: @user, status: :created, location: @user }
    #   else
    #     format.html { render "new" }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    if @current_user.can_edit_delete_profile?(@user)
      @user.destroy
      redirect_to root_path, :notice => "You have deleted your account."
    else
      redirect_to issues_path, :notice => "You are not authorized to delete other users"
    end
  end

  def admin
    @user = User.find(params[:id])
    if @current_user.admin?
      @user.set_as_admin 
      @user.save
      redirect_to users_path
    end
  end

  def notadmin
    @user = User.find(params[:id])
    if @current_user.admin?
      @user.set_as_student
      @user.save
      redirect_to users_path
    end
  end

  def indexadmin
    @admins = User.admin

    if @current_user.admin?
      respond_to do |format|
        format.html # indexadmin.html.erb
        format.json { render json: @users }
      end
    else
      redirect_to issues_path, :notice => "Sorry, only admins have access to users index."
    end
  end

  def toggle_oncall
    @admin = User.find(params[:id])

    if @current_user.admin?
      case @admin.on_call
      when true
        @admin.on_call = false
      else
        @admin.on_call = true
      end
      @admin.save
    end

    redirect_to indexadmin_path, :notice => "Hey #{@current_user.name}, you toggled #{@admin.name}'s on-call status to #{@admin.on_call}"
  end

end
