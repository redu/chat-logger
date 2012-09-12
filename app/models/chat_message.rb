class ChatMessage < ActiveRecord::Base
  attr_accessible :message
  belongs_to :chat
end
