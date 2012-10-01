require 'spec_helper'

describe User do
  # Username
  it { should respond_to(:username) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  # Uid
  it { should respond_to(:uid) }
  it { should validate_presence_of(:uid) }
  it { should validate_uniqueness_of(:uid) }

  # First and last names
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }

  # Role
  it { should respond_to(:role) }
  # it { should validate_presence_of(:role) }

  # Chat
  it { should have_many(:chats) }

  describe 'find_or_create_with_omniauth' do
    before do
      @space = FactoryGirl.create(:space)
    end

    context 'when user does exist' do
      before do
        @user = FactoryGirl.create(:student)
        @space.users << @user
        @auth = { 'uid' => @user.uid, 'credentials' => {'token' => 'asdASD'} }
      end

      it 'should not create a new user' do
        expect {
          User.find_or_create_with_omniauth(@auth, @space.sid)
        }.to_not change(User, :count).by(1)
      end

      it 'should return the desired user' do
        User.find_or_create_with_omniauth(@auth, @space.sid).should == @user
      end

      it 'should update user token' do
        User.find_or_create_with_omniauth(@auth, @space.sid).token.should ==
          @auth['credentials']['token']
      end
    end # context 'when user does exist'

    context 'when user does not exist' do
      before do
        @auth = { 'uid' => '123', 'credentials' => {'token' => '231asd123'},
                  'info' => {'name' => 'Joao', 'login' => 'joaodasilva'}}
        stub_request(:get, "http://redu.com.br/api/spaces/#{@space.sid}/users?role=member").
         to_return(:body => "[ {\"id\": #{@auth['uid']}} ]")
      end

      it 'should create a new user' do
        expect {
          User.find_or_create_with_omniauth(@auth, @space.sid)
        }.to change(User, :count).by(1)
      end

      it 'should create an user with received uid' do
        User.find_or_create_with_omniauth(@auth, @space.sid).uid.should.to_s ==
          @auth['uid']
      end

      it 'should update user token' do
        User.find_or_create_with_omniauth(@auth, @space.sid).token.should ==
          @auth['credentials']['token']
      end
    end # context 'when user does not exist'
  end # describe 'find_or_create_with_omniauth'

  describe 'find_by_api' do
    before do
      @user = FactoryGirl.create(:student)
      @user.update_attributes(:token => 'asd123asd')
      @url = "http://www.redu.com.br/api/users/#{@user.username}"
      stub_request(:get, "http://www.redu.com.br/api/users/#{@user.username}").
        to_return(:body => "{ \"id\": #{@user.uid} }")
    end

    it 'should return desired user' do
      User.find_by_api(@url, @user.token).should == @user
    end
  end # describe 'find_by_api'

  describe 'find_by_url' do
    before do
      @user = FactoryGirl.create(:student)
      @url = "http://www.redu.com.br/api/users/#{@user.username}"
    end

    it 'should return desired user' do
      User.find_by_url(@url).should == @user
    end
  end
end
