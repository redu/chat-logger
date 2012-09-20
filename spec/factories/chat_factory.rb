# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat do 
    association :user, factory: :student
    association :contact, factory: :mentor

    after(:create) do |chat|
      6.times do | n |
        if n.odd?
          chat.chat_messages << FactoryGirl.create(:chat_message,
                                                   :chat => chat,
                                                   :user => chat.user,
                                                   :contact => chat.contact)
        else
          chat.chat_messages << FactoryGirl.create(:chat_message,
                                                   :chat => chat,
                                                   :user => chat.contact,
                                                   :contact => chat.user)
        end
      end
    end
  end
end
