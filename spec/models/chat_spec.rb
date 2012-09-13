require 'spec_helper'

describe Chat do
  it { should have_many(:chat_messages) }
  it { should respond_to(:user) }
end
