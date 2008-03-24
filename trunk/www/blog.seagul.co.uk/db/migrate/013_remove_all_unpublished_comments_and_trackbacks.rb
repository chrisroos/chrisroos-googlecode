class RemoveAllUnpublishedCommentsAndTrackbacks < ActiveRecord::Migration
  
  def self.up
    warn "You should only run this migration once you're happy that all non-published comments and trackbacks are actually spam (use bin/check-comments-for-spam.rb and bin/check-trackbacks-for-spam.rb)"
    
    delete "DELETE FROM comments WHERE published = FALSE"
    delete "DELETE FROM trackbacks WHERE published = FALSE"
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
  
end