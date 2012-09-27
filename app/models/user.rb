class User < ActiveRecord::Base
  attr_accessible :username, :first_name, :last_name, :token, :uid, :role

  # Username
  validates_presence_of :username
  validates_uniqueness_of :username

  # Uid
  validates_presence_of :uid
  validates_uniqueness_of :uid

  # Chat
  has_many :chats, :dependent => :destroy

  # Role
  belongs_to :role
  # validates_presence_of :role

  # Space
  belongs_to :space

  def find_all_chats
    t = Chat.arel_table

    Chat.where(t[:user_id].eq(self.id).or(t[:contact_id].eq(self.id)))
  end

  def refresh_chats(space)
    url = "/api/users/#{self.username}/chats"
    chats = JSON.parse Connection.get(url, self.token).body

    # Cria chats que eventualmente ainda não existem
    chats.each do | redu_chat |
      contact_link = redu_chat["links"].select { |l| l["rel"] == "contact" }
      contact = User.find_by_api(contact_link.first["href"], 
                                 self.token)
      cid = redu_chat["id"]
      # Não criar chats para contatos não existentes ou não vinculados à disciplina
      if (contact && space.users.include?(contact) && !Chat.find_by_cid(cid))
        chat = Chat.create do | chat |
          chat.cid = redu_chat["id"]
          chat.user = self
          chat.contact = contact
        end
        ChatMessage.create_messages_for(chat)
        self.chats << chat
      end
    end

    # Atualiza chats já existentes (que podem ter ganhado novas mensagens)
    self.chats.each do | chat |
      chat.refresh!(self.token)
    end
  end

  def self.find_or_create_with_omniauth(auth, space_id)
    user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth, 
                                                                      space_id)
    token = auth["credentials"]["token"]
    user.update_attributes(:token => token) if token

    user
  end

  def self.find_by_api(url, token)
    user = JSON.parse Connection.get(url, token).body

    User.find_by_uid(user["id"])
  end

  def self.create_by_api(redu_user, space, token)
    create! do | user |
      user.uid = redu_user["id"]
      user.username = redu_user["login"]
      user.first_name = redu_user["first_name"]
      user.role = User.consult_role_by_api(user, space.sid, token)
    end
  end

  private

  def self.create_with_omniauth(auth, space_id)
    create! do | user |
      user.uid = auth["uid"]
      user.token = auth["credentials"]["token"]
      user.first_name = auth["info"]["name"]
      user.username = auth["info"]["login"]
      user.role = User.consult_role_by_api(user, space_id, user.token)
    end
  end

  def self.consult_role_by_api(user, space_id, token)
    members = JSON.parse Connection.get("/api/spaces/#{space_id}/users?role=member", token).body
    return Role.find(1) if (members.select { |m| m["id"] == user.uid }).length != 0
    teachers = JSON.parse Connection.get("/api/spaces/#{space_id}/users?role=teacher", token).body
    return Role.find(3) if (teachers.select { |m| m["id"] == user.uid }).length != 0
    admins = JSON.parse Connection.get("/api/spaces/#{space_id}/users?role=environment_admin", token).body
    return Role.find(2) if (admins.select { |m| m["id"] == user.uid }).length != 0
    tutors = JSON.parse Connection.get("/api/spaces/#{space_id}/users?role=tutor", token).body
    return Role.find(4) if (tutors.select { |m| m["id"] == user.uid }).length != 0
  end
end
