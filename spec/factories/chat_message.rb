# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat_message do
    message 'This webpage is not available'
    chat
  end
end
