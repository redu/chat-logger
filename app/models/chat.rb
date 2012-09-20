class Chat < ActiveRecord::Base
  attr_accessible :contact, :chat_messages
  belongs_to :user
  belongs_to :contact, :class_name => 'User', :foreign_key => 'contact_id'
  has_many :chat_messages, :dependent => :destroy

  def self.update_chats_for(user, space)
    conn = Faraday.new(:url => 'http://redu.com.br/api') do | faraday |
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    token = user.token

    conn.headers = { 'Authorization' => "OAuth #{token}", 
                     'Content-type' => 'application/json' }
    chats = JSON.parse conn.get("/api/users/#{user.username}/chats").body
    
    chats.each do | redu_chat |
      links = redu_chat["links"].select { |l| l["rel"] == "contact" }
      contact = User.find_by_api(links.first["href"], 
                                 token)
      cid = redu_chat["id"]
      # Não criar chats para contatos não existentes ou não vinculados à disciplina
      if (contact && space.users.include?(contact) && !Chat.find_by_cid(cid))
        chat = create! do | chat |
          chat.cid = redu_chat["id"]
          chat.user = user
          chat.contact = contact
        end
        ChatMessage.create_messages_for(chat)
        user.chats << chat
      end
    end
  end

end
