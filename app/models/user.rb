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

  # Recupera ou cria usuário de acordo com hash omniauth
  # O segundo parâmetro, space_id, diz respeito ao ID da disciplina no Redu
  # - isto é, deve ser o sid do Space
  def self.find_or_create_with_omniauth(auth, space_id)
    user = User.find_by_uid(auth["uid"]) || User.create_with_omniauth(auth, 
                                                                      space_id)
    token = auth["credentials"]["token"]
    user.update_attributes(:token => token) if token

    user
  end

  # Recupera um usuário existente a partir de sua url do Redu
  # fazendo uma requisição à API - muito mau!
  # Substituir por User.find_by_url sempre que possível
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

  # Recupera um usuário existente a partir de sua url do Redu
  # sem fazer requisições externas - muito bom!
  # Usar este método em lugar de find_by_api sempre que possível
  def self.find_by_url(url)
    User.find_by_username(url.split(/\/ */).last)
  end

  private

  # Cria um novo usuário com os dados da hash do omniauth
  # O id do space é necessário para consultar o papel do usuário na disciplina
  # Atentar que o space_id passado deve ser, na realidade, o sid do Space
  def self.create_with_omniauth(auth, space_id)
    create! do | user |
      user.uid = auth["uid"]
      user.token = auth["credentials"]["token"]
      user.first_name = auth["info"]["name"]
      user.username = auth["info"]["login"]
      user.role = User.consult_role_by_api(user, space_id, user.token)
    end
  end

  # Consulta o papel de um usuário em uma disciplina do Redu a partir de
  # requisições à API
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
