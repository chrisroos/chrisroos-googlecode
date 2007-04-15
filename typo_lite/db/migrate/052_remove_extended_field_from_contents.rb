class RemoveExtendedFieldFromContents < ActiveRecord::Migration
  
  def self.up
    remove_column :contents, :extended
  end

  def self.down
    add_column :contents, :extended, :text
  end
  
end