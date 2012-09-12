class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.belongs_to :user
      t.integer :contact_id

      t.timestamps
    end
    add_index :chats, :user_id
  end
end
