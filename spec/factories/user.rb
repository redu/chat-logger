# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "aluno#{n}" }
    sequence(:first_name, 'a') { |n| "Mart#{n}" }
    sequence(:uid) { |n| n }
    last_name  "Yed"

    factory :student_user do
      role Role.find_by_name('aluno')
    end

    factory :admin_user do
      role Role.find_by_name('administrador')
    end

    factory :professor_user do
      role Role.find_by_name('professor')
    end

    factory :tutor_user do
      Role.find_by_name('tutor')
    end
  end
end
