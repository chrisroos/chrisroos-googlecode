class DateIsEnoughGranularityForEditionPublishedAt < ActiveRecord::Migration
  
  def self.up
    change_column :editions, :published_at, :date
    rename_column :editions, :published_at, :published_on
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end