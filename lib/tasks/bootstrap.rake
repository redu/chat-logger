namespace :bootstrap do
  desc "Create roles"
  task :create_roles => :environment do
    Role.create(:name => 'administrador')
    Role.create(:name => 'professor')
    Role.create(:name => 'tutor')
    Role.create(:name => 'aluno')
  end

  desc "Run all bootstrapping tasks"
  task :all => [:create_roles]
end
