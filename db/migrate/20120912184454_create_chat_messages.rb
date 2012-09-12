class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.belongs_to :chat
      t.text :message

      t.timestamps
    end
  end
end
