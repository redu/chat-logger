class ChatMessage < ActiveRecord::Base
  attr_accessible :message, :sent_at
  belongs_to :chat
  belongs_to :user
  belongs_to :contact, :class_name => 'User', :foreign_key => 'contact_id'

  validates_presence_of :message, :sent_at

  def self.create_messages_for(chat)
    conn = Faraday.new(:url => 'http://redu.com.br/api') do | faraday |
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    token = chat.user.token

    conn.headers = { 'Authorization' => "OAuth #{token}", 
                     'Content-type' => 'application/json' }
    chat_messages = JSON.parse conn.get("/api/chats/#{chat.cid}/chat_messages").body

    chat_messages.each do | redu_chat_message |
      chat_message = create! do | chat_message |
        chat_message.cmid = redu_chat_message["id"]
        chat_message.message = redu_chat_message["message"]
        links = redu_chat_message["links"]
        user_url = links.select { |l| l["rel"] == "user" }
        contact_url = links.select { |l| l["rel"] == "contact" }
        chat_message.user = User.find_by_api(user_url.first["href"], token)
        chat_message.contact = User.find_by_api(contact_url.first["href"], token)
        chat_message.sent_at = DateTime.parse(redu_chat_message["created_at"])
      end

      chat.chat_messages << chat_message
    end
  end

end
