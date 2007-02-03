class AddResourceHabtmTagsTables < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.column :name, :string
    end
    create_table(:resources_tags, :id => false) do |t|
      t.column :resource_id, :integer
      t.column :tag_id, :integer
    end
  end

  def self.down
    drop_table :tags
    drop_table :resources_tags
  end
end
