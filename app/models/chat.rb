class Chat < ActiveRecord::Base
  attr_accessible :contact, :messages
  belongs_to :user
  has_many :chat_messages
end
