require 'test/unit'
require 'delicious'

class BookmarkTest < Test::Unit::TestCase
  
  def test_should_be_equal_if_title_and_description_and_tags_and_url_are_all_the_same
    bookmark_1 = Bookmark.new('d' => 'title', 'n' => 'description', 't' => ['tags'], 'u' => 'url')
    bookmark_2 = Bookmark.new('d' => 'title', 'n' => 'description', 't' => ['tags'], 'u' => 'url')
    assert_equal bookmark_1, bookmark_2
  end
  
  def test_should_not_be_equal_if_title_and_description_and_tags_and_equal_but_url_is_different
    bookmark_1 = Bookmark.new('d' => 'title', 'n' => 'description', 't' => ['tags'], 'u' => 'url_1')
    bookmark_2 = Bookmark.new('d' => 'title', 'n' => 'description', 't' => ['tags'], 'u' => 'url_2')
    assert_not_equal bookmark_1, bookmark_2
  end
  
  def test_should_not_be_equal_if_title_and_description_and_url_are_equal_but_tags_are_different
    bookmark_1 = Bookmark.new('d' => 'title', 'n' => 'description', 't' => ['tags_1'], 'u' => 'url')
    bookmark_2 = Bookmark.new('d' => 'title', 'n' => 'description', 't' => ['tags_2'], 'u' => 'url')
    assert_not_equal bookmark_1, bookmark_2
  end
  
  def test_should_not_be_equal_if_title_and_tags_and_url_and_equal_but_description_is_different
    bookmark_1 = Bookmark.new('d' => 'title', 'n' => 'description_1', 't' => ['tags'], 'u' => 'url')
    bookmark_2 = Bookmark.new('d' => 'title', 'n' => 'description_2', 't' => ['tags'], 'u' => 'url')
    assert_not_equal bookmark_1, bookmark_2
  end
  
  def test_should_not_be_equal_if_description_and_tags_and_url_are_equal_but_title_is_different
    bookmark_1 = Bookmark.new('d' => 'title_1', 'n' => 'description', 't' => ['tags'], 'u' => 'url')
    bookmark_2 = Bookmark.new('d' => 'title_2', 'n' => 'description', 't' => ['tags'], 'u' => 'url')
    assert_not_equal bookmark_1, bookmark_2
  end
  
  def test_should_intersect_the_tags_to_find_the_tags_in_common
    bookmark_1 = Bookmark.new('t' => [1, 2, 3])
    bookmark_2 = Bookmark.new('t' => [2, 3, 4])
    assert_equal [2, 3], bookmark_1.tags_in_common(bookmark_2)
  end
  
end

class BookmarksTest < Test::Unit::TestCase
  
  def test_should_order_the_bookmarks_by_the_number_of_tags_that_they_have_in_common_with_the_current_site
    # It'd probably be useful to deterministically order on the date of the post - we don't get this info in json feeds though
    current_site = Bookmark.new('u' => 'current_site', 't' => ['t1', 't2'])
    bookmark_1 = Bookmark.new('u' => 'bookmark_1', 't' => ['t1'])
    bookmark_2 = Bookmark.new('u' => 'bookmark_2', 't' => ['t1', 't2'])
    bookmark_3 = Bookmark.new('u' => 'bookmark_3', 't' => ['t1', 't2', 't3'])
    bookmarks = Bookmarks.new(current_site, bookmark_1, bookmark_2, bookmark_3)
    
    yielded_bookmarks = []; bookmarks.each { |bookmark| yielded_bookmarks << bookmark }
    assert_equal [bookmark_3, bookmark_2, bookmark_1], yielded_bookmarks
  end
  
  def test_should_ignore_the_current_site_if_it_appears_in_the_bookmarks
    current_site = Bookmark.new('u' => 'current_site', 't' => ['t1', 't2'])
    bookmark_1 = Bookmark.new('u' => 'current_site', 't' => ['t1', 't2'])
    bookmarks = Bookmarks.new(current_site, bookmark_1)
   
    yielded_bookmarks = []; bookmarks.each { |bookmark| yielded_bookmarks << bookmark }
    assert_equal [], yielded_bookmarks
  end
  
  def test_should_yield_each_bookmark
    current_site = Bookmark.new('u' => 'current_site', 't' => ['t1'])
    bookmark_1 = Bookmark.new('u' => 'bookmark_1', 't' => ['t1'])
    bookmarks = Bookmarks.new(current_site, bookmark_1)
    
    yielded_bookmarks = []; bookmarks.each { |bookmark| yielded_bookmarks << bookmark }
    assert_equal [bookmark_1], yielded_bookmarks
  end
  
  def test_should_retain_a_reference_to_the_current_site_as_we_want_to_deal_with_it_as_a_special_case_in_the_template
    current_site = Bookmark.new('u' => 'current_site', 't' => ['t1'])
    bookmarks = Bookmarks.new(current_site)
    
    assert_equal current_site, bookmarks.current_site
  end
  
  def test_should_ignore_duplicate_bookmarks
    current_site = Bookmark.new('u' => 'current_site', 't' => ['t1'])
    bookmark_1 = Bookmark.new('u' => 'bookmark', 't' => ['t1'])
    bookmark_2 = Bookmark.new('u' => 'bookmark', 't' => ['t1'])
    bookmarks = Bookmarks.new(current_site, bookmark_1, bookmark_2)
    
    yielded_bookmarks = []; bookmarks.each { |bookmark| yielded_bookmarks << bookmark }
    assert_equal [bookmark_1], yielded_bookmarks
  end
  
end