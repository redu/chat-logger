class Chat < ActiveRecord::Base
  attr_accessible :contact, :chat_messages
  belongs_to :user
  belongs_to :contact, :class_name => 'User', :foreign_key => 'contact_id'
  has_many :chat_messages, :dependent => :destroy
end
