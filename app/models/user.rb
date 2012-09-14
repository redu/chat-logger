class User < ActiveRecord::Base
  attr_accessible :username, :first_name, :last_name

  # Username
  validates_presence_of :username
  validates_uniqueness_of :username

  # Role
  has_one :role
  validates_presence_of :role

  # Chat
  has_many :chats
end
