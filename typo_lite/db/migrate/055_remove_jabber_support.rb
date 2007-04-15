class RemoveJabberSupport < ActiveRecord::Migration
  
  def self.up
    remove_column :users, :notify_via_jabber
    remove_column :users, :jabber
  end

  def self.down
    add_column :users, :notify_via_jabber, :boolean
    add_column :users, :jabber, :string
  end
  
end