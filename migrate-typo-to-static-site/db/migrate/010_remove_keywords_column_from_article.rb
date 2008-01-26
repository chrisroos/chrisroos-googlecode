class RemoveKeywordsColumnFromArticle < ActiveRecord::Migration
  
  def self.up
    remove_column :articles, :keywords
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end