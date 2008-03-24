class RemoveAuthorFromArticles < ActiveRecord::Migration
  
  def self.up
    remove_column :articles, :author
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end