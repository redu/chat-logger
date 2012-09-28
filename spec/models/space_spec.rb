require 'spec_helper'

describe Space do
  # Space id (sid)
  it { should respond_to(:sid) }

  # Users
  it { should have_many(:users) }

  describe 'refresh!' do
    before do
      @space = FactoryGirl.create(:space)
      @user = FactoryGirl.create(:user)
      @token = 'bah'
    end

    context 'when no change is needed' do
      before do
        @space.users << @user
        stub_request(:get, "http://redu.com.br/api/spaces/#{@space.sid}/users").
           to_return(:body => '[{"id": ' + @user.uid.to_s + '}]')
      end

      it 'should not change space users' do
        expect {
          @space.refresh!(@token)
        }.to_not change(@space.users, :count).by(1)
      end

      it 'should not create any user' do
        expect {
          @space.refresh!(@token)
        }.to_not change(User, :count).by(1)
      end
    end

    context 'when there is a new user in redu space but the user already exists' do
      before do
        stub_request(:get, "http://redu.com.br/api/spaces/#{@space.sid}/users").
           to_return(:body => '[{"id": ' + @user.uid.to_s + '}]')
      end

      it 'should add the new space user' do
        expect {
          @space.refresh!(@token)
        }.to change(@space.users, :count).by(1)
      end

      it 'should not create any user' do
        expect {
          @space.refresh!(@token)
        }.to_not change(User, :count).by(1)
      end
    end

    context 'when there is a new user in redu space that does not exist yet' do
      before do
        @space.users << @user # O usuário antigo já está incluído
        @new_user = FactoryGirl.build(:user)
        stub_request(:get, "http://redu.com.br/api/spaces/#{@space.sid}/users").
           to_return(:body => '[{"id": ' + @new_user.uid.to_s + ', ' + \
                               '"login": "' + @new_user.username + '", ' +\
                               '"first_name": "' + @new_user.first_name + '"},'+ \
                              ' {"id": ' + @user.uid.to_s + '}]')
        stub_request(:get, "http://redu.com.br/api/spaces/#{@space.sid}/users?role=member").
           to_return(:body => '[{"id": ' + @user.uid.to_s + '},' + \
                              ' {"id": ' + @new_user.uid.to_s + '}]')
      end

      it 'should add the new space user' do
        expect {
          @space.refresh!(@token)
        }.to change(@space.users, :count).by(1)
      end

      it 'should create new user' do
        expect {
          @space.refresh!(@token)
        }.to change(User, :count).by(1)
      end
    end
  end # describe refresh!
end
