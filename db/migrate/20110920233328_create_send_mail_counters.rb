class CreateSendMailCounters < ActiveRecord::Migration
  def self.up
    create_table :send_mail_counters do |t|
      t.integer :counter
      t.timestamps
    end
  end

  def self.down
    drop_table :send_mail_counters
  end
end
