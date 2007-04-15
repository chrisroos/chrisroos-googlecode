class RemoveResources < ActiveRecord::Migration
  
  def self.up
    drop_table :resources
  end

  def self.down
    create_table :resources do |table|    
      table.column :size, :integer 
      table.column :filename, :string
      table.column :mime, :string
      table.column :created_at, :datetime   
      table.column :updated_at, :datetime    
      table.column :article_id, :integer
      table.column :itunes_metadata, :boolean
      table.column :itunes_author, :string
      table.column :itunes_subtitle, :string
      table.column :itunes_duration, :integer
      table.column :itunes_summary, :text     
      table.column :itunes_keywords, :string
      table.column :itunes_category, :string
      table.column :itunes_explicit, :boolean
    end
  end
  
end