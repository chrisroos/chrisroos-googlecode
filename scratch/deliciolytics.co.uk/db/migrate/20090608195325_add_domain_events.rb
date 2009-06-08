class AddDomainEvents < ActiveRecord::Migration
  
  def self.up
    create_table :domain_events, :force => true do |t|
      t.integer  :domain_id
      t.string   :description
      # t.timestamps
      t.datetime :started_at
      t.datetime :finished_at
    end
  end

  def self.down
    drop_table :domain_events
  end
  
end