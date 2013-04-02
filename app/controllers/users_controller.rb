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
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
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
    
    case @user.email 
      when "bob@flatironschool.com"
        @user.set_as_admin
      when "avi@flatironschool.com"
        @user.set_as_admin
      else
        @user.set_as_student
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to issues_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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
      redirect_to root_path, :notic => "You have deleted your account."
    else
      redirect_to issues_path, :notice => "You are not authorized to delete other users"
    end
  end
end