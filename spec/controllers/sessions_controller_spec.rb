require 'spec_helper'

describe SessionsController do

  describe 'GET create' do
    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:redu]
      stub_request(:get, "http://redu.com.br/api/spaces/users?role=member").
        to_return(:body => '[{"id": 1}, {"id": 2}]')
    end

    context 'when user does not exist' do
      it 'should create a new user' do
        expect {
          get :create
        }.to change(User, :count).by(1)
      end

      it 'should assign user' do
        get :create
        assigns(:user).should_not be_nil
      end

      it 'should assign session user uid' do
        get :create
        controller.session[:user_uid].should == 1
      end
    end

    context 'when user does exist' do
      before do
        @user = FactoryGirl.create(:user)
        request.env['omniauth.auth']['uid'] = @user.uid
        stub_request(:get, "http://redu.com.br/api/spaces/users?role=member").
          to_return(:body => '[{"id": 1}, {"id": 2}], {"id": #{@user.uid}}]')
      end

      it 'should not create a new user' do
        expect {
          get :create
        }.to_not change(User, :count).by(1)
      end

      it 'should assign user' do
        get :create
        assigns(:user).should_not be_nil
      end

      it 'should assign session user uid' do
        get :create
        controller.session[:user_uid].should == @user.uid
      end
    end
  end

end
