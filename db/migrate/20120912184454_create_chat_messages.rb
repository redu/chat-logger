class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.belongs_to :chat
      t.belongs_to :user
      t.belongs_to :contact
      t.text :message
      t.datetime :sent_at

      t.timestamps
    end
    add_index :chat_messages, :user_id
    add_index :chat_messages, :contact_id
  end
end
