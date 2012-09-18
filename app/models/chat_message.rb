class ChatMessage < ActiveRecord::Base
  attr_accessible :message, :sent_at
  belongs_to :chat
  belongs_to :user
  belongs_to :contact, :class_name => 'User', :foreign_key => 'contact_id'

  validates_presence_of :message, :sent_at
end
