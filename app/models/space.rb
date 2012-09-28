class Space < ActiveRecord::Base
  attr_accessible :sid

  has_many :users

  # Atualiza disciplina, incluindo todos seus usuários
  # Caso algum usuário retornado pela requisição à API ainda não exista, um novo
  # usuário é criado através da chamada a User.create_by_api
  def refresh!(token)
    url = "/api/spaces/#{self.sid}/users"
    users = JSON.parse Connection.get(url, token).body
    users.each do | redu_user |
      unless self.users.include?(User.find_by_uid(redu_user["id"]))
        user = User.find_by_uid(redu_user["id"]) || User.create_by_api(redu_user, self, token)
        self.users << user
      end
    end
  end

  # Encontra ou cria disciplina
  # Se já existe uma disciplina com o sid recebido, ela é retornada. Se não, uma
  # nova disciplina é criada com a chamada a Space.create_from_redu
  # Além de recuperar a disciplina, checa se o usuário está vinculado a ela
  def self.find_or_create_by_sid(sid, current_user)
    space = Space.find_by_sid(sid) || Space.create_from_redu(sid, current_user)
    space.refresh!(current_user.token)
    if space.users.include?(current_user)
      return space
    else
      return nil
    end
  end

  private

  # Cria uma disciplina com os dados recebidos da API do Redu
  # Tal criação implica a possível criação dos usuários da disciplina - feita
  # através de chamadas (podem ser muitas!) a User.create_by_api
  def self.create_from_redu(sid, current_user)
    create! do | space |
      space.sid = sid
      token = current_user.token
      url = "/api/spaces/#{sid}/users"
      users = JSON.parse Connection.get(url, token).body
      users.each do | redu_user |
        user = User.find_by_uid(redu_user["id"]) || User.create_by_api(redu_user, space, token)
        space.users << user
      end
    end
  end
end
