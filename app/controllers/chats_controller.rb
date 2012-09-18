class ChatsController < ApplicationController
  def index
    if params[:user_id]
      @chats = User.find(params[:user_id]).chats
      render 'user_chats'
    else
      redirect_to root
    end
  end

  def show
    @chat = Chat.find(params[:id])
    render 'show'
  end
end
