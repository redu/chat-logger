# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    name "AnotherBrickInTheWall"
  end

  factory :tutor, class: Role do
    name "tutor"
  end

  factory :admin, class: Role do
    name "administrador"
  end

  factory :mentor, class: Role do
    name "mentor"
  end

  factory :student, class: Role do
    name "aluno"
  end
end
