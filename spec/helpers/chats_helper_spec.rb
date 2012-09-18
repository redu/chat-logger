require 'spec_helper'

describe ChatsHelper do
  describe "Messages per day" do
    before do
      @chat = FactoryGirl.create(:chat)
      5.times do | n |
        @chat.chat_messages << FactoryGirl.create(:chat_message, :chat => @chat,
                                                 :sent_at => n.days.ago)
      end
      @ret = messages_per_day(@chat)
    end

    it "shouldn't return null" do
      @ret.length.should_not == 0
    end

    it "should return same number of chat messages" do
      returned_messages = 0
      @ret.each do | msg_per_day |
        returned_messages = returned_messages + msg_per_day.count
      end
      returned_messages.should == @chat.chat_messages.count
    end

    it "should separate messages per day" do
      @ret.each do | msg_per_day |
        day = msg_per_day.first.sent_at.day
        msg_per_day.each do |msg|
          msg.sent_at.day.should == day
        end
      end
    end
  end
end
