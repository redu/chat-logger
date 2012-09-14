require 'spec_helper'

describe Role do
  # Name
  it { should respond_to(:name) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  # Users
  it { should respond_to(:users) }
end
