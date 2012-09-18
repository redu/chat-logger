module UsersHelper
  def user_chats(user)
    t = Chat.arel_table
    Chat.where(t[:user_id].eq(user.id).or(t[:contact_id].eq(user.id)))
  end
end
