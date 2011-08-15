class CreateAuthorizedUsers < ActiveRecord::Migration
  def self.up
    create_table :authorized_users do |t|
      t.string :user_name
      t.string :user_id
      t.string :email
      t.timestamps
    end
  end

  def self.down
    drop_table :authorized_users
  end
end
