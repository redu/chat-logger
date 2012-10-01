class Chat < ActiveRecord::Base
  attr_accessible :contact, :chat_messages

  # Users
  belongs_to :user
  validates_presence_of :user
  belongs_to :contact, :class_name => 'User', :foreign_key => 'contact_id'
  validates_presence_of :contact

  # Chat messages
  has_many :chat_messages, :dependent => :destroy

  # Atualiza as chat messages do chat
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

  # Atualiza todos os chats para todos os usuários de uma determinada disciplina
  # sob a condição de o usuário possuir token de acesso
  def self.refresh(current_space)
    current_space.users.each do | user |
      unless !user.token
        Chat.update_chats_for(user, current_space)
      end
    end
  end

  private

  # Atualiza todos os chats para um determinado usuário em relação a uma 
  # determinada disciplina
  def self.update_chats_for(user, space)
    token = user.token
    url = "/api/users/#{user.username}/chats"
    chats = JSON.parse Connection.get(url, token).body

    chats.each do | redu_chat |
      contact_link = redu_chat["links"].select { |l| l["rel"] == "contact" }
      contact = User.find_by_url(contact_link.first["href"])
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

    # Atualiza chats já existentes (que podem ter ganhado novas mensagens)
    user.chats.each do | chat |
      chat.refresh!(user.token)
    end
  end

end
