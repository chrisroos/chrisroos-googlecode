class RemoveRedirects < ActiveRecord::Migration
  
  def self.up
    drop_table :redirects
  end

  def self.down
    create_table :redirects do |table|
      table.column :from_path, :string
      table.column :to_path, :string
    end
  end
  
end