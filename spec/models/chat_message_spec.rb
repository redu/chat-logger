require 'spec_helper'

describe ChatMessage do
  it { should belong_to(:chat) }
  it { should respond_to(:message) }
  it { should respond_to(:user) }
  it { should respond_to(:contact) }
  it { should respond_to(:sent_at)}
  it { should validate_presence_of(:message)}
  it { should validate_presence_of(:sent_at)}
end
