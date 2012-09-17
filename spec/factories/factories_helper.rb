module FactoriesHelper
  def rulez(role)
    after(:create) do |user|
      user.update_attributes(:role => Role.find(role))
    end
  end
end