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
      # Cria outro chat para o mesmo user
      FactoryGirl.create(:chat, :user => chat.user)
      # Cria mensagem em dia diferente para o mesmo chat
      chat.chat_messages << FactoryGirl.create(:chat_message, 
                                               :chat => chat,
                                               :sent_at => 1.day.ago)
      chat.chat_messages << FactoryGirl.create(:chat_message, 
                                               :chat => chat,
                                               :sent_at => 2.day.ago)
    end
  end

  desc "Run all bootstrapping tasks"
  task :all => [:create_roles]
end
