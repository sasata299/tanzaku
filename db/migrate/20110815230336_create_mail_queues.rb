class CreateMailQueues < ActiveRecord::Migration
  def self.up
    create_table :mail_queues do |t|
      t.string :common_user_id
      t.string :user_id
      t.string :target_user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :mail_queues
  end
end
