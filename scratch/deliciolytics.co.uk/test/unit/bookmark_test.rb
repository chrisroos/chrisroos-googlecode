require File.join(File.dirname(__FILE__), '..', 'test_helper')

class BookmarkTest < Test::Unit::TestCase
  
  def test_should_build_from_delicious_bookmark_attributes
    delicious_bookmark_attributes = {
      "a" => "blackerby", 
      "n" => "", 
      "d" => "Connecting to gmail with Ruby (or Connecting to POP3 servers over SSL with Ruby) - Chris Roos", 
      "dt" => "2009-05-20T20:19:27Z", 
      "t" => ["ruby", "gmail", "ssl"], 
      "u" => "http://chrisroos.co.uk/blog/2006-10-24-connecting-to-gmail-with-ruby-or-connecting-to-pop3-servers-over-ssl-with-ruby"
    }
    
    bookmark = Bookmark.new_from_delicious_attributes(delicious_bookmark_attributes)
    
    assert_equal delicious_bookmark_attributes['a'],     bookmark.username
    assert_equal delicious_bookmark_attributes['n'],     bookmark.notes
    assert_equal delicious_bookmark_attributes['d'],     bookmark.title
    assert_equal delicious_bookmark_attributes['t'],     bookmark.tags
    assert_equal DateTime.parse('2009-05-20T20:19:27Z'), bookmark.bookmarked_at
  end
  
end