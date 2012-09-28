ChatLogger::Application.routes.draw do
  root :to => 'users#index'

  get 'sessions/create'
  match '/auth/:provider/callback', :to => 'sessions#create'

  resources :spaces, :only => [] do
    resources :users, :only => :index do
      resources :chats, :only => [:index, :show]
    end
  end

end
