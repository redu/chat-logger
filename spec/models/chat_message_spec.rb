require 'spec_helper'

describe ChatMessage do
  it { should respond_to(:message) }
  it { should belong_to(:user) }
  it { should belong_to(:contact) }
end
