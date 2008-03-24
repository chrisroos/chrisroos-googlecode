class UnpublishSpamComments < ActiveRecord::Migration
  
  def self.up
    update "UPDATE comments SET published = false WHERE id in (163, 2439, 2681, 2682, 23244, 52651, 52652, 60260, 64396, 72994, 78223)"
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end