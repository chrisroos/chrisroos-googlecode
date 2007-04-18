class RemoveSidebars < ActiveRecord::Migration
  
  def self.up
    drop_table :sidebars
  end

  def self.down
    create_table :sidebars do |table|
      table.column :controller, :string, :limit => 32
      table.column :active_position, :integer
      table.column :config, :text
      table.column :staged_position, :integer
      table.column :updated_at, :datetime
    end
  end
  
end