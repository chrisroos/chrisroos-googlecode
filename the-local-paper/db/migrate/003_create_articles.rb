class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column :edition_id, :integer
      t.column :page_number, :integer
      t.column :author, :string
      t.column :title, :string
    end
  end

  def self.down
    drop_table :articles
  end
end
