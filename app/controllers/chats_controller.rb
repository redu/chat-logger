class ChatsController < ApplicationController

  before_filter :check_login, :check_membership, :update_chats

  def index
    @space = current_space
    @user = User.find(params[:user_id])
    @chats = @user.find_all_chats
    render 'user_chats'
  end

  def show
    @space = current_space
    @chat = Chat.find(params[:id])
  end
end
