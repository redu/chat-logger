class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :cid
      t.belongs_to :user
      t.belongs_to :contact

      t.timestamps
    end
    add_index :chats, :cid
    add_index :chats, :user_id
    add_index :chats, :contact_id
  end
end
