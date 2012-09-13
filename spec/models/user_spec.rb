require 'spec_helper'

describe User do
  it { should respond_to(:username) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should have_many(:chats) }
end
