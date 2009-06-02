class AddBookmarks < ActiveRecord::Migration
  
  def self.up
    create_table :bookmarks, :force => true do |t|
      t.integer    :url_id
      t.string     :username
      t.string     :title
      t.text       :notes
      t.text       :tags
      t.datetime   :bookmarked_at
      t.timestamps
    end
  end

  def self.down
    drop_table :bookmarks
  end
  
end