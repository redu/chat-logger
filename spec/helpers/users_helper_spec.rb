require 'spec_helper'

describe UsersHelper do
  describe "User chats" do
    before do
      @chat = FactoryGirl.create(:chat)
      @user = @chat.user
      @contact = @chat.contact
    end

    it "should return the chat for user chats" do
      user_chats(@user).should include(@chat)
    end

    it "should return the chat for contact chats" do
      user_chats(@contact).should include(@chat)
    end
  end
end
