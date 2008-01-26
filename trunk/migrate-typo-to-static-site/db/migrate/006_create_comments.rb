class CreateComments < ActiveRecord::Migration
  
  def self.up
    create_table :comments do |table|
      table.column :author, :string
      table.column :body, :text
      table.column :created_at, :datetime
      table.column :updated_at, :datetime
      table.column :article_id, :integer
      table.column :email, :string
      table.column :url, :string
      table.column :ip, :string
      table.column :published, :boolean
      table.column :published_at, :datetime
    end
    insert "INSERT INTO comments SELECT id, author, body, created_at, updated_at, article_id, email, url, ip, published, published_at FROM contents WHERE type = 'comment'"
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end