class User < ActiveRecord::Base
  attr_accessible :username, :first_name, :last_name, :role

  # Username
  validates_presence_of :username
  validates_uniqueness_of :username

  # Chat
  has_many :chats, :dependent => :destroy

  # Role
  belongs_to :role

  def find_all_chats
    t = Chat.arel_table
    Chat.where(t[:user_id].eq(user.id).or(t[:contact_id].eq(user.id)))
  end    

end
