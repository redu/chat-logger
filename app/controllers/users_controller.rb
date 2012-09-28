class UsersController < ApplicationController

  before_filter :check_login, :check_membership, :update_chats

  # root
  # GET /spaces/:space_id/users
  def index
    @space = current_space
    @user = current_user
    @users = current_space.users
  end
end
