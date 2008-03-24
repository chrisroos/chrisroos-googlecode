class CreateTrackbacks < ActiveRecord::Migration
  
  def self.up
    create_table :trackbacks do |table|
      table.column :title, :string
      table.column :excerpt, :text
      table.column :article_id, :integer
      table.column :url, :string
      table.column :ip, :string, :limit => 40
      table.column :blog_name, :string
      table.column :published, :boolean
      table.column :published_at, :datetime
    end
    insert "INSERT INTO trackbacks SELECT id, title, excerpt, article_id, url, ip, blog_name, published, published_at FROM contents WHERE type = 'trackback'"
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end