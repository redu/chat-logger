class User < ActiveRecord::Base
  attr_accessible :username
  validates_presence_of :username
  has_many :chats
end
