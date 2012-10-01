class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :current_space, :check_login, :check_membership

  protected

  # Retorna o usuário da sessão
  def current_user
    User.find_by_uid(session[:user_uid])
  end

  # Retorna a disciplina da sessão
  def current_space
    Space.find_by_sid(session[:space_sid])
  end
  
  # Verifica se existe um usuário da sessão e, caso não exista, redireciona para
  # a página de login / acesso externo (Redu)
  def check_login
    # Seta disciplina da sessão
    session[:space_sid] = params[:space_id] if params[:space_id]

    unless current_user
      redirect_to '/auth/redu'
    end
  end

  # i) Verifica se existe uma disciplina da sessão
  # ii) Verifica se o usuário da sessão tem acesso à disciplina da sessão
  # iii) Renderiza página de acesso negado caso o usuário não tenha acesso
  def check_membership
    check_space # Remove a disciplina da sessão caso o usuário não tenha acesso
    unless current_space
      render :file => 'public/401', :status => :unauthorized
    end
  end

  # Atualiza os chats para todos os usuários da disciplina da sessão
  def update_chats
    Chat.refresh(current_space)
  end

  private

  # Verifica / cria o espaço da sessão e atribui seu id à session[:space_sid]
  # se o usuário da sessão tiver acesso à disciplina
  def check_space
    sid = params[:space_id] || session[:space_sid]

    # Space.find_or_create_by_sid retorna nil caso o usuário não participe
    # da disciplina
    space = Space.find_or_create_by_sid(sid, current_user)
    if space
      session[:space_sid] = Space.find_or_create_by_sid(sid, current_user).sid
    else
      session[:space_sid] = nil
    end
  end

end
