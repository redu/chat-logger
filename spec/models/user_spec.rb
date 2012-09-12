require 'spec_helper'

describe User do
  it { should respond_to(:username) }
  it { should validate_presence_of(:username) }
  it { should have_many(:chats) }
end
