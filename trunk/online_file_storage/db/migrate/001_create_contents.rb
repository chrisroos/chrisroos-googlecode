class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.column :title, :string
      t.column :body, :text
    end
  end

  def self.down
    drop_table :contents
  end
end
