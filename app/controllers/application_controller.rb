class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :current_space, :check_login, :check_membership

  protected

  def current_user
    User.find_by_uid(session[:user_uid])
  end

  def current_space
    Space.find_by_sid(session[:space_sid])
  end
  
  def check_login
    # Seta disciplina da sessão
    session[:space_sid] = params[:space_id] if params[:space_id]

    unless current_user
      redirect_to '/auth/redu'
    end
  end

  def check_membership
    check_space
    unless current_space
      render :file => 'public/401', :status => :unauthorized
    end
  end

  def update_chats
    Chat.refresh(current_user, current_space)
  end

  private

  def check_space
    sid = params[:space_id] || session[:space_sid]
    space = Space.find_or_create_by_sid(sid, current_user)
    if space
      session[:space_sid] = space.sid
    else
      session[:space_sid] = nil
    end
  end

end
