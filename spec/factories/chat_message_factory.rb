# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat_message do
    association :user, factory: :student
    association :contact, factory: :mentor
    message 'This webpage is not available'
    sent_at Time.now
    chat
  end
end
