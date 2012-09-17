module UsersHelper
  def user_chats(user_id)
    t = Chat.arel_table
    Chat.where(t[:user_id].eq(user_id).or(t[:contact_id].eq(user_id)))
  end
end
