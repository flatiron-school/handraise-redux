require 'spec_helper'

describe IssuesController do

  context 'Test issues for existing user' do
    before(:each) do
      @current_user = User.create(
        :email => "test@gmail.com",
        :password => "test",
        :name => "test"
        )
      session[:user_id] = @current_user.id

      @issue = Issue.create(
        :title => "Test issue title",
        :content => "Test issue content Test issue content Test issue content Test issue content Test issue content Test issue content Test issue content"
        )

      @issue_params = {
        :title => @issue.title,
        :content => @issue.content
      }
    end
    
    describe 'GET new' do 
      it 'should be successful' do
        get :new
        response.should be_success
      end

      it 'instantiates an issue' do
        get :new
        assigns(:issue).should be_an_instance_of(Issue)
      end

      it 'instantiates a new issue if user does not have an open issue' do
        get :new

        assigns(:issue).should be_a_new_record
      end

      it 'redirects to issues path if user has current issue' do 
        @current_user.issues << @issue
        get :new
        response.status.should equal 302
      end

    end

    describe 'POST create' do
      context 'if user creates gist' do
        it 'posts the issue gist to Github' do 
          # @issue_params["relevant_gist"] = "Test gist"
          # post :create, {:issue => @issue_params}
          # @issue.gist_id.should be_a_new_record
        end
        it 'assigns the gist to the issue' do
        end
      end

      context 'if user does not create gist' do

      end

      context 'if there are no assignable issues before user creates issue, send Twilio text' do

      end

      # it 'prevents a user from creating an issue if user has an open issue' do
      #   @current_user.issues << @issue
      #   post :create, {:issue => @issue_params}
      # end
    end

  end

end