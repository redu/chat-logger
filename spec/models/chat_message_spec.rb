require 'spec_helper'

describe ChatMessage do
  it { should belong_to(:chat) }
  it { should respond_to(:message) }
end
