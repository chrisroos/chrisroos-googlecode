class RemoveCategories < ActiveRecord::Migration
  
  def self.up
    drop_table :categories
    drop_table :articles_categories
  end

  def self.down
    create_table :categories do |table|
      table.column :name, :string
      table.column :position, :integer
      table.column :permalink, :string
    end
    create_table :articles_categories do |table|
      table.column :article_id, :integer
      table.column :category_id, :integer
      table.column :is_primary, :boolean
    end
  end
  
end