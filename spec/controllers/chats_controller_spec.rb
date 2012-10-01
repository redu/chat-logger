require 'spec_helper'

describe ChatsController do

  it "should check log in" do
    get :index, :user_id => 123, :space_id => 123
    response.should redirect_to('/auth/redu')
  end

  it "should check current user membership within current space" do
    uid = FactoryGirl.create(:user).uid
    sid = FactoryGirl.create(:space).sid
    session[:user_uid] = uid
    session[:space_sid] = sid
    stub_request(:get, 
                  "http://redu.com.br/api/spaces/#{session[:space_sid]}/users").
      to_return(:body => "{}")
    get :index, :user_id => uid, :space_id => sid
    response.status.should == 401
  end

  # Exibe todos os chats de um determinado usuário
  # GET /spaces/:space_id/users/:user_id/chats     chats#index
  describe "GET index" do
    before do
      @user = FactoryGirl.create(:student)
      @space = FactoryGirl.create(:space)
      session[:user_uid] = @user.uid
      session[:space_sid] = @space.sid
      @space.users << @user
      @user.chats << FactoryGirl.create(:chat, :user => @user)
      stub_request(:get, 
                    "http://redu.com.br/api/spaces/#{session[:space_sid]}/users").
        to_return(:body => "{}")
      get :index, :user_id => @user.id, :space_id => @space.sid
    end

    it "should assign user chats" do
      assigns(:chats).should == @user.chats
    end

    it "should render user chats" do
      response.should render_template('user_chats')
    end
  end

  # Exibe as mensagens de um chat
  # GET /spaces/:space_id/users/:user_id/chats/:id   chats#show
  describe "GET show" do
    before do
      @user = FactoryGirl.create(:student)
      @space = FactoryGirl.create(:space)
      @chat = FactoryGirl.create(:chat, :user => @user)
      session[:user_uid] = @user.uid
      session[:space_sid] = @space.sid
      @space.users << @user
      stub_request(:get, 
                    "http://redu.com.br/api/spaces/#{session[:space_sid]}/users").
        to_return(:body => "{}")
      get :show, :user_id => @user.uid, :space_id => @space.sid, :id => @chat.id
    end

    it "should assign the chat" do
      assigns(:chat).should eq(@chat)
    end

    it "should render chat view" do
      response.should render_template('show')
    end

    it "should respond with 200 status code" do
      response.status.should == 200
    end
  end
end
