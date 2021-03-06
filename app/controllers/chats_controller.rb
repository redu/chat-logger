class ChatsController < ApplicationController

  before_filter :check_login, :check_membership, :update_chats

  # GET /spaces/:space_id/users/:user_id/chats
  def index
    @space = current_space
    @user = User.find(params[:user_id])
    @chats = @user.chats
    render 'user_chats'
  end

  # GET /spaces/:space_id/users/:user_id/chats/
  def show
    @space = current_space
    @chat = Chat.find(params[:id])
  end
end
