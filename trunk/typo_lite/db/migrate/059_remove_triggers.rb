class RemoveTriggers < ActiveRecord::Migration
  
  def self.up
    drop_table :triggers
  end

  def self.down
    create_table :triggers do |t|
      t.column :pending_item_id, :integer
      t.column :pending_item_type, :string
      t.column :due_at, :datetime
      t.column :trigger_method, :string
    end
  end
  
end
class RemoveTriggers < ActiveRecord::Migration
  
  def self.up
    drop_table :triggers
  end

  def self.down
    create_table :triggers do |t|
      t.column :pending_item_id, :integer
      t.column :pending_item_type, :string
      t.column :due_at, :datetime
      t.column :trigger_method, :string
    end
  end
  
end