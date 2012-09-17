class User < ActiveRecord::Base
  attr_accessible :username, :first_name, :last_name, :role

  # Username
  validates_presence_of :username
  validates_uniqueness_of :username

  # Chat
  has_many :chats, :dependent => :destroy

  # Role
  belongs_to :role


end
