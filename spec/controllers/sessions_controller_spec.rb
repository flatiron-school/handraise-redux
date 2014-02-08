require 'spec_helper'

describe SessionsController do
  describe 'Authentication' do 
    describe "User" do
      it 'Successful login' do
        user = stub_model(User, admin?: false, id: 1)
        user.stub(:authenticate) { true }
        User.stub(:find_by_email) { user }

        post :create, {email: 'test@example.com', password: 'secret'}
        user = assigns(:user) 
        expect(user).not_to be_nil
        expect(subject).to redirect_to(user_path(user))
      end

      it "Failed login with bad password" do
        user = stub_model(User)
        User.stub(:find_by_email) { user }
        user.stub(:authenticate) { false }

        post :create, {email: 'test@example.com', password: 'bogus'}
        expect(subject).to redirect_to(login_path)
      end

      it "Failed login with email password" do
        user = stub_model(User)
        User.stub(:find_by_email) { nil }

        post :create, {email: 'not_found@example.com', password: 'bogus'}
        expect(subject).to redirect_to(login_path)
      end
    end
    describe "Admin" do
      it 'Successful login' do
        user = stub_model(User, admin?: true, id: 1)
        user.stub(:authenticate) { true }
        User.stub(:find_by_email) { user }

        post :create, {email: 'test@example.com', password: 'secret'}
        user = assigns(:user) 
        expect(user).not_to be_nil
        expect(subject).to redirect_to(issues_path)
      end
    end
  end
end
