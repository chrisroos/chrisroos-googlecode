class RemoveTablesForActsAsTaggable < ActiveRecord::Migration
  def self.up
    drop_table :tags
    drop_table :taggings
  end

  def self.down
    create_table :tags do |t|
      t.column :name, :string
    end
    create_table :taggings do |t|
      t.column :taggable_id, :integer
      t.column :taggable_type, :string
      t.column :tag_id, :integer
    end
  end
end
