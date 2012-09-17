# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat do 
    association :user, factory: :student
    association :contact, factory: :mentor

    ignore do
      posts_count 5
    end

    after(:create) do |chat, evaluator|
      FactoryGirl.create_list(:chat_message, evaluator.posts_count, chat: chat)
    end
  end
end
