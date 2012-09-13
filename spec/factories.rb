FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "aluno#{n}" }
    sequence(:first_name, 'a') { |n| "Mart#{n}" }
    last_name  "Yed"
  end

  factory :chat do
    association :user
    contact FactoryGirl.create(:user)

    ignore do
      posts_count 5
    end

    after(:create) do |chat, evaluator|
      FactoryGirl.create_list(:chat_message, evaluator.posts_count, chat: chat)
    end
  end

  factory :chat_message do
    message 'This webpage is not available'
    chat
  end
end
