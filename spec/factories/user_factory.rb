# Read about factories at https://github.com/thoughtbot/factory_girl

include FactoriesHelper
FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "aluno#{n}" }
    sequence(:first_name, 'a') { |n| "Mart#{n}" }
    sequence(:uid) { |n| n }
    last_name  "Yed"

    factory :student do
      rulez(1)
    end

    factory :admin do
      rulez(2)
    end

    factory :mentor do
      rulez(3)
    end

    factory :tutor do
      rulez(4)
    end
  end
end
