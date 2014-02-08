require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      @logged_in = logged_in?
      @current_user = current_user
      render text: "OK"
    end
  end
  describe "helper methods" do
    describe "not being authenticated" do
      it "redirects by default" do
        get :index
        expect(subject).to redirect_to login_path
      end
    end

    describe "being logged in" do 
      before do
        login_user
        get :index
      end
      it "renders action if logged in" do
        expect(response).to be_success
      end

      it "knows if user is logged in" do
        expect(assigns(:logged_in)).to be_true
      end
      it "knows current user" do
        expect(assigns(:current_user).id).to eq 1
      end
    end
  end

  def login_user
    user = stub_model(User, id: 1)
    session[:user_id] = 1
    User.stub(:find) { user }
  end
end
