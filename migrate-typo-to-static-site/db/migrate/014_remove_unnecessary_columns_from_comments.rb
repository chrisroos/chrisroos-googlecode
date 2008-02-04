class RemoveUnnecessaryColumnsFromComments < ActiveRecord::Migration
  
  def self.up
    update "UPDATE comments SET published_at = created_at WHERE published_at IS NULL"
    
    remove_column :comments, :created_at
    remove_column :comments, :updated_at
    remove_column :comments, :email
    remove_column :comments, :ip
    remove_column :comments, :published
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end