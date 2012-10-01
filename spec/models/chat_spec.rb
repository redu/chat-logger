require 'spec_helper'

describe Chat do
  # Users
  it { should respond_to(:user) }
  it { should validate_presence_of(:user) }
  it { should respond_to(:contact) }
  it { should validate_presence_of(:contact) }

  # Chat messages
  it { should have_many(:chat_messages) }

  describe 'refresh!' do
    before do
      @chat = FactoryGirl.create(:chat)
    end

    context 'when there are not new chat messages' do
      before do
        test_msg = @chat.chat_messages.last
        stub_request(:get, "http://redu.com.br/api/chats/#{@chat.cid}/chat_messages").
          to_return(:body => "[ {\"id\": #{test_msg.cmid}} ]")
      end

      it 'should not create new chat messages' do
        expect {
          @chat.refresh!("token")
        }.to_not change(ChatMessage, :count).by(1)
      end
    end

    context 'when there is a new chat message' do
      before do
        existent_cmid = '"id": ' + @chat.chat_messages.last.cmid.to_s
        stub_request(:get, "http://redu.com.br/api/chats/#{@chat.cid}/chat_messages").
          to_return(:body => '[
            { "links": [
                    {
                        "rel": "self",
                        "href": "http://127.0.0.1:3000/api/chat_messages/16"
                    },
                    {
                        "rel": "user",
                        "href": "http://127.0.0.1:3000/api/users/guiocavalcanti"
                    },
                    {
                        "rel": "contact",
                        "href": "http://127.0.0.1:3000/api/users/tiago"
                    }
                ],
                "id": 165,
                "created_at": "2011-06-29T13:15:18-03:00",
                "message": "Opa!"
            }, {'+existent_cmid+'}, {'+existent_cmid+'}, {'+existent_cmid+'}, 
            {'+existent_cmid+'}, {'+existent_cmid+'}, {'+existent_cmid+'}]')
      end

      it 'should create a new chat message' do
        expect {
          @chat.refresh!("token")
        }.to change(ChatMessage, :count).by(1)
      end

      it 'should create a new chat message for the chat' do
        expect {
          @chat.refresh!("token")
        }.to change(@chat.chat_messages, :count).by(1)
      end
    end
  end

  describe 'refresh all chats for all current space users' do
    before do
      @space = FactoryGirl.create(:space)
    end

    context 'when users do not have access token' do
      before do
        5.times do
          @space.users << FactoryGirl.create(:student)
        end
      end

      it 'should not create new chats' do
        expect { 
          Chat.refresh(@space)
        }.to_not change(Chat, :count).by(1)
      end

      it 'should not create new chat messages' do
        expect { 
          Chat.refresh(@space)
        }.to_not change(ChatMessage, :count).by(1)
      end
    end

    context 'when user does have access token' do
      before do
        5.times do | n |
          @space.users << FactoryGirl.create(:student)
        end
        @user = @space.users.last
        @contact = @space.users.first
        @user.update_attributes(:token => 'asdasd123')
      end

      context 'and there is a new chat for some user' do

        context 'which contact belongs to same space' do
          before do
            stub_request(:get, "http://redu.com.br/api/users/#{@user.username}/chats").
              to_return(:body => '[
                {
                  "links": [
                    {
                      "rel": "self",
                      "href": "http://redu.com.br/api/chats/1475"
                    },
                    {
                      "rel": "user",
                      "href": "http://redu.com.br/api/users/'+@user.username+'"
                    },
                    {
                      "rel": "contact",
                      "href": "http://redu.com.br/api/users/'+@contact.username+'"
                    },
                    {
                      "rel": "chat_messages",
                      "href": "http://redu.com.br/api/chats/1475/chat_messages"
                    }
                  ],
                  "id": 1475,
                  "created_at": "2012-09-19T15:29:13-03:00"
                }]')

            stub_request(:get, "http://redu.com.br/api/chats/1475/chat_messages").
              to_return(:body => '[
                {
                  "links": [
                    {
                      "rel": "self",
                      "href": "http://redu.com.br/api/chat_messages/16"
                    },
                    {
                      "rel": "user",
                      "href": "http://redu.com.br/api/users/'+@user.username+'"
                    },
                    {
                      "rel": "contact",
                      "href": "http://redu.com.br/api/users/'+@contact.username+'"
                    }
                  ],
                  "id": 16,
                  "created_at": "2011-06-29T13:15:18-03:00",
                  "message": "Opa!"
                }]')
          end

          it 'should create new chat' do
            expect {
              Chat.refresh(@space)
            }.to change(Chat, :count).by(1)
          end

          it 'should create new chat for the user' do
            expect {
              Chat.refresh(@space)
            }.to change(@user.chats, :count).by(1)
          end

          it 'should create new chat message' do
            expect {
              Chat.refresh(@space)
            }.to change(ChatMessage, :count).by(1)
          end
        end

        context 'which contact does not belong to same space' do
          before do
            stub_request(:get, "http://redu.com.br/api/users/#{@user.username}/chats").
              to_return(:body => '[
                {
                  "links": [
                    {
                      "rel": "self",
                      "href": "http://redu.com.br/api/chats/1475"
                    },
                    {
                      "rel": "user",
                      "href": "http://redu.com.br/api/users/'+@user.username+'"
                    },
                    {
                      "rel": "contact",
                      "href": "http://redu.com.br/api/users/umestranho"
                    },
                    {
                      "rel": "chat_messages",
                      "href": "http://redu.com.br/api/chats/1475/chat_messages"
                    }
                  ],
                  "id": 1475,
                  "created_at": "2012-09-19T15:29:13-03:00"
                }]'
              )
          end

          it 'should not create new chats' do
            expect { 
              Chat.refresh(@space)
            }.to_not change(Chat, :count).by(1)
          end

          it 'should not create new chat messages' do
            expect { 
              Chat.refresh(@space)
            }.to_not change(ChatMessage, :count).by(1)
          end
        end # context 'which contact does not belong to same space'
      end # context 'and there is a new chat for some user'
    end # context 'when user does have access token'
  end # describe 'refresh all chats for all current space users'

end
