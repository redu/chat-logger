require 'spec_helper'

describe "Chats routes" do
  it "routes index to users#index which exposes all chats" do
    expect(:get => '/').to route_to(:controller => 'users', :action => 'index')
  end

  # space_user_chat GET /spaces/:space_id/users/:user_id/chats/:id chats#show
  it "routes to chat visualization" do
    space = FactoryGirl.create(:space)
    user = FactoryGirl.create(:user)
    chat = FactoryGirl.create(:chat)
    url = "/spaces/#{space.id}/users/#{user.id}/chats/#{chat.id}"
    expect(:get => url).to route_to(:controller => 'chats', 
                                    :action => 'show',
                                    :id => chat.id.to_s,
                                    :space_id => space.id.to_s,
                                    :user_id => user.id.to_s)
  end

  #space_user_chats GET /spaces/:space_id/users/:user_id/chats     chats#index
  it "routes to user chats visualization" do
    space = FactoryGirl.create(:space)
    user = FactoryGirl.create(:user)
    url = "/spaces/#{space.id}/users/#{user.id}/chats"
    expect(:get => url).to route_to(:controller => 'chats',
                                    :action => 'index',
                                    :space_id => space.id.to_s,
                                    :user_id => user.id.to_s)
  end
end
