module ChatsHelper  
  def messages_per_day(chat)
    per_day = Array.new
    all = Array.new
    day = 0
    chat.chat_messages.each do |message|
      if day != message.sent_at.day
        day = message.sent_at.day
        all << per_day if per_day.length != 0
        per_day = Array.new
      end
      per_day << message
    end
    all << (per_day.sort_by &:sent_at) if per_day.length != 0
    
    all
  end

  def sort_by_date

  end
end
