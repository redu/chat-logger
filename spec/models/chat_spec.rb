require 'spec_helper'

describe Chat do
  # Chat messages
  it { should have_many(:chat_messages) }

  # Users
  it { should respond_to(:user) }
  it { should respond_to(:contact) }
end
