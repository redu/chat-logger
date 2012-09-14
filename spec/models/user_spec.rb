require 'spec_helper'

describe User do
  # Username
  it { should respond_to(:username) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  # First and last names
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }

  # Role
  it { should respond_to(:role) }
  it { should validate_presence_of(:role) }

  # Chat
  it { should have_many(:chats) }
end
