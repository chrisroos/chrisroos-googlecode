class CreatePages < ActiveRecord::Migration
  
  def self.up
    create_table :pages do |table|
      table.column :title, :string
      table.column :body, :text
      table.column :created_at, :datetime
      table.column :updated_at, :datetime
      table.column :name, :string
    end
    insert "INSERT INTO pages SELECT id, title, body, created_at, updated_at, name FROM contents WHERE type = 'page'"
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end