class RemoveUnnecessaryColumns < ActiveRecord::Migration
  
  def self.up
    execute "ALTER TABLE tags DROP COLUMN created_at" # I don't use this in any of my templates
    execute "ALTER TABLE tags DROP COLUMN updated_at" # I don't use this in any of my templates
    execute "ALTER TABLE tags DROP COLUMN display_name" # I use name rather than display_name
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end