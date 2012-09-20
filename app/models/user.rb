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

  def self.find_or_create_with_omniauth(auth, space)
    user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth, space)
    token = auth["credentials"]["token"]
    user.update_attributes(:token => token) if token

    user
  end

  def self.find_by_api(url, token)
    conn = Faraday.new(:url => 'http://redu.com.br/api') do | faraday |
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    conn.headers = { 'Authorization' => "OAuth #{token}", 
                     'Content-type' => 'application/json' }
    user = JSON.parse conn.get(url).body

    User.find_by_uid(user["id"])
  end

  def self.create_by_api(redu_user, space, token)
    create! do | user |
      user.uid = redu_user["id"]
      user.username = redu_user["login"]
      user.first_name = redu_user["first_name"]
      user.role = User.consult_role_by_api(user, space, token)
    end
  end

  private

  def self.create_with_omniauth(auth, space)
    create! do | user |
      user.uid = auth["uid"]
      user.token = auth["credentials"]["token"]
      user.first_name = auth["info"]["name"]
      user.username = auth["info"]["login"]
      user.role = User.consult_role_by_api(user, space, user.token)
    end
  end

  def self.consult_role_by_api(user, space, token)
    conn = Faraday.new(:url => 'http://redu.com.br/api') do | faraday |
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    conn.headers = { 'Authorization' => "OAuth #{token}", 
                     'Content-type' => 'application/json' }
    
    members = JSON.parse conn.get("/api/spaces/#{space.sid}/users?role=member").body
    return Role.find(1) if (members.select { |m| m["id"] == user.uid }).length != 0
    teachers = JSON.parse conn.get("/api/spaces/#{space.sid}/users?role=teacher").body
    return Role.find(3) if (teachers.select { |m| m["id"] == user.uid }).length != 0
    admins = JSON.parse conn.get("/api/spaces/#{space.sid}/users?role=environment_admin").body
    return Role.find(2) if (admins.select { |m| m["id"] == user.uid }).length != 0
    tutors = JSON.parse conn.get("/api/spaces/#{space.sid}/users?role=tutor").body
    return Role.find(4) if (tutors.select { |m| m["id"] == user.uid }).length != 0
  end
end
