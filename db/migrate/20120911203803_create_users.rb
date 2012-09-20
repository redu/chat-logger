class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.integer :uid
      t.string :token
      t.string :first_name
      t.string :last_name
      t.belongs_to :role
      t.belongs_to :space

      t.timestamps
    end
    add_index :users, :uid
    add_index :users, :token
  end
end
