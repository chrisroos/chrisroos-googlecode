class RemoveUnnecessaryTables < ActiveRecord::Migration
  
  def self.up
    %w[blogs sessions text_filters triggers users pings resources redirects page_caches notifications categories blacklist_patterns articles_categories sidebars excerpts].each do |table_name|
      drop_table table_name
    end
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end