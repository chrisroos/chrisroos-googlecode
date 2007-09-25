class CreateEditions < ActiveRecord::Migration
  def self.up
    create_table :editions do |t|
      t.column :paper_id, :integer
      t.column :published_on, :datetime
      t.column :label, :string
    end
  end

  def self.down
    drop_table :editions
  end
end
