require 'spec_helper'

describe IssuesController do

  before(:each) do
    @current_user = User.create(
      :email => "test@gmail.com",
      :password => "test",
      :name => "test"
      )
    session[:user_id] = @current_user.id
    # ApplicationController.stub!(:logged_in?).and_return(true)
  end
  
  describe 'GET new' do 
    it 'should be successful' do
      get :new
      response.should be_success
    end

    it 'instantiates an issue' do
      get 'new'
      binding.pry
      assigns(:issue).should == Issue.new
    end

    it 'instantiates a new issue if user does not have an open issue' do
      # get :new
      # assigns(:issue).should be_an_instance_of(Issue)
      # current_user = User.new


      # assigns(:issue).should be_a_new_record

    end

    it 'prevents a user from creating an issue if user has an open issue' do
    end

  end

  describe '#create' do
  end

end