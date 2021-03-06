class SessionsController < ApplicationController

  # GET /sessions/create
  # GET /auth/:provider/callback
  def create
    @user = current_user || User.find_or_create_with_omniauth(auth_hash, 
                                                              session[:space_sid])
    session[:user_uid] = @user.uid

    redirect_to root_path, :space_id => session[:space_sid]
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
