# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "aluno#{n}" }
    sequence(:first_name, 'a') { |n| "Mart#{n}" }
    last_name  "Yed"
  end
end
