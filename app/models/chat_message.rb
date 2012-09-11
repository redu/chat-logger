class ChatMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :contact, :class_name => 'User', :foreign_key => 'contact_id'
  attr_accessible :message
end
