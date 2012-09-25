class Connection < ActiveRecord::Base
  def self.get(url, token)
    conn = Faraday.new(:url => 'http://redu.com.br/api') do | faraday |
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
    conn.headers = { 'Authorization' => "OAuth #{token}", 
                     'Content-type' => 'application/json' }
    
    conn.get(url)
  end
end
