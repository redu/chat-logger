namespace :bootstrap do
  desc "Create roles"
  task :create_roles => :environment do
    Role.create(:name => 'aluno')
    Role.create(:name => 'administrador')
    Role.create(:name => 'mentor')
    Role.create(:name => 'tutor')
  end

  desc "Create initial data"
  task :populate => :environment do
    5.times do
      chat = FactoryGirl.create(:chat)
      FactoryGirl.create(:chat, :user => chat.user)
    end
  end

  desc "Run all bootstrapping tasks"
  task :all => [:create_roles]
end
