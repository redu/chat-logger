class Space < ActiveRecord::Base
  attr_accessible :sid

  has_many :users

  # Além de recuperar a disciplina, checa se o usuário está vinculado a ela
  def self.find_or_create_by_sid(sid, current_user)
    space = Space.find_by_sid(sid) || Space.create_from_redu(sid, current_user)
    if space.users.include?(current_user)
      return space
    else
      return nil
    end
  end

  private

  def self.create_from_redu(sid, current_user)
    create! do | space |
      space.sid = sid
      token = current_user.token
      conn = Faraday.new(:url => 'http://redu.com.br/api') do | faraday |
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
      conn.headers = { 'Authorization' => "OAuth #{token}", 
                       'Content-type' => 'application/json' }

      users = JSON.parse conn.get("/api/spaces/#{sid}/users").body
      users.each do | redu_user |
        user = User.find_by_uid(redu_user["id"]) || User.create_by_api(redu_user, space, token)
        space.users << user
      end
    end
  end
end
