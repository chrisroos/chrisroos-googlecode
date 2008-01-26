class RemoveContentsTable < ActiveRecord::Migration
  
  def self.up
    drop_table :contents
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end