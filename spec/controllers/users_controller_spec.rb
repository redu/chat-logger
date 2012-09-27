require 'spec_helper'

describe UsersController do

  it "should check log in" do
    get :index, :space_id => 123
    response.should redirect_to('/auth/redu')
  end

  it "should check current user membership within current space" do
    session[:user_uid] = FactoryGirl.create(:user).uid
    session[:space_sid] = FactoryGirl.create(:space).sid
    stub_request(:get, 
                  "http://redu.com.br/api/spaces/#{session[:space_sid]}/users").
      to_return(:body => "{}")
    get :index
    response.status.should == 401
  end

  # Mostra todos os usuários e seus chats
  describe "GET index" do
    context "with a valid request" do
      before do
        @space = FactoryGirl.create(:space)
        @user = FactoryGirl.create(:user)
        @space.users << @user
        session[:user_uid] = @user.uid
        session[:space_sid] = @space.sid
        stub_request(:get, 
                      "http://redu.com.br/api/spaces/#{session[:space_sid]}/users").
          to_return(:body => "{}")
        get :index
      end

      it "should assign users" do
        assigns(:users).should eq(User.all)
      end

      it "renders index" do
        response.should render_template('index')
      end
    end
  end
end
