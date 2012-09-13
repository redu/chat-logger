class User < ActiveRecord::Base
  attr_accessible :username, :first_name, :last_name
  validates_presence_of :username
  validates_uniqueness_of :username
  has_many :chats
end
