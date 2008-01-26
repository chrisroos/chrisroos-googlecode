class CreateArticles < ActiveRecord::Migration
  
  def self.up
    create_table :articles do |table|
      table.column :title, :string
      table.column :author, :string
      table.column :body, :text
      table.column :keywords, :string
      table.column :guid, :string
      table.column :published_at, :datetime
    end
    insert "INSERT INTO articles SELECT id, title, author, body, keywords, guid, published_at FROM contents WHERE type = 'Article'"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end