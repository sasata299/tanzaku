class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.string :user_id
      t.string :user_name
      t.string :profile_url
      t.timestamps
    end
  end

  def self.down
    drop_table :friends
  end
end
