class AddUrlsTable < ActiveRecord::Migration
  
  def self.up
    create_table :urls, :force => true do |t|
      t.string :url
      t.string :url_hash
      t.string :title
      t.integer :total_posts
      t.text :top_tags
      t.timestamps
    end
  end

  def self.down
    drop_table :urls
  end
  
end