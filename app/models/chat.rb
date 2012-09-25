class Chat < ActiveRecord::Base
  attr_accessible :contact, :chat_messages
  belongs_to :user
  belongs_to :contact, :class_name => 'User', :foreign_key => 'contact_id'
  has_many :chat_messages, :dependent => :destroy

  def refresh!(token)
    url = "/api/chats/#{self.cid}/chat_messages"
    messages = JSON.parse Connection.get(url, token).body
    return unless messages.count > self.chat_messages.count
    messages.each do | redu_message |
      unless ChatMessage.find_by_cmid(redu_message["id"])
        self.chat_messages << ChatMessage.create_by_api(redu_message, token)
      end
    end
  end

  def self.refresh(current_user, current_space)
    current_space.users.each do | user |
      unless !user.token
        user.refresh_chats(user.token, current_space)
      end
    end
  end

  def self.update_chats_for(user, space)
    token = user.token
    url = "/api/users/#{user.username}/chats"
    chats = JSON.parse Connection.get(url, token).body
    
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
