require 'spec_helper'

describe ChatMessage do
  # Chat
  it { should belong_to(:chat) }
  it { should respond_to(:message) }
  it { should validate_presence_of(:message)}
  it { should validate_presence_of(:sent_at)}

  # Users
  it { should respond_to(:user) }
  it { should respond_to(:contact) }

  # Datetime
  it { should respond_to(:sent_at)}

  describe 'create_messages_for' do
    before do
      @user = FactoryGirl.create(:student)
      @contact = FactoryGirl.create(:mentor)
      @chat = FactoryGirl.create(:chat, :user => @user, :contact => @contact)

      stub_request(:get, "http://redu.com.br/api/chats/#{@chat.cid}/chat_messages").
        to_return(:body => '[
          {
            "links": [
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
            "id": 16,
            "created_at": "2011-06-29T13:15:18-03:00",
            "message": "Opa!",
            "updated_at": "2011-06-29T13:15:18-03:00"
          },
          {
            "links": [
              {
                "rel": "self",
                "href": "http://127.0.0.1:3000/api/chat_messages/34"
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
            "id": 34,
            "created_at": "2011-06-29T13:55:35-03:00",
            "message": "Todo mundo com foto",
            "updated_at": "2011-06-29T13:55:35-03:00"
          }
      ]')

    end

    it 'should create 2 new chat messages' do
      expect {
        ChatMessage.create_messages_for(@chat)
      }.to change(ChatMessage, :count).by(2)
    end

    it 'should create 2 new chat messages for the correct chat' do
      expect {
        ChatMessage.create_messages_for(@chat)
      }.to change(@chat.chat_messages, :count).by(2)    end
  end # describe 'create_messages_for'

  describe 'create_by_api' do
    before do
      @user_url = "http://127.0.0.1:3000/api/users/guiocavalcanti"
      @contact_url = "http://127.0.0.1:3000/api/users/tiago"
      @redu_chat_message = { 
        "links" => [
          {
            "rel" => "self",
            "href" => "http://127.0.0.1:3000/api/chat_messages/34"
          },
          {
            "rel" => "user",
            "href" => @user_url
          },
          {
            "rel" => "contact",
            "href" => @contact_url
          }
        ],
        "id" => 34,
        "created_at" => "2011-06-29T13:55:35-03:00",
        "message" => "Todo mundo com foto",
        "updated_at" => "2011-06-29T13:55:35-03:00"
      }
    end

    it 'should create a new chat message' do
      expect {
        ChatMessage.create_by_api(@redu_chat_message, 'token')
      }.to change(ChatMessage, :count).by(1)
    end

    it 'should set cmid for the new chat message' do
      ChatMessage.create_by_api(@redu_chat_message, 'token').cmid.should ==
        @redu_chat_message["id"]
    end

    it 'should set message for the new chat message' do
      ChatMessage.create_by_api(@redu_chat_message, 'token').message.should ==
        @redu_chat_message["message"]
    end

    it 'should set user for the new chat message' do
      ChatMessage.create_by_api(@redu_chat_message, 'token').user.should ==
        User.find_by_url(@user_url)
    end

    it 'should set contact for the new chat message' do
      ChatMessage.create_by_api(@redu_chat_message, 'token').contact.should ==
        User.find_by_url(@contact_url)
    end

    it 'should set sent_at for the new chat message' do
      ChatMessage.create_by_api(@redu_chat_message, 'token').sent_at.should ==
        DateTime.parse(@redu_chat_message["created_at"])
    end
  end
end
