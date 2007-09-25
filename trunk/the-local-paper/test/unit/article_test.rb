require File.dirname(__FILE__) + '/../test_helper'

class ArticlesTest < Test::Unit::TestCase

  def test_should_belong_to_edition
    edition = Edition.new
    article = Article.new(:edition => edition)
    assert_equal edition, article.edition
  end
  
  def test_should_validate_presence_of_title
    article = Article.new(:title => nil)
    article.valid?
    assert_equal "can't be blank", article.errors[:title]
  end
  
  def test_should_validate_presence_of_page_number
    article = Article.new(:page_number => nil)
    article.valid?
    assert_equal "can't be blank", article.errors[:page_number]
  end
  
  def test_should_not_validate_presence_of_author_as_small_articles_dont_have_authors
    article = Article.new(:author => nil)
    article.valid?
    assert_nil article.errors[:author]
  end
  
  def test_should_validate_presence_of_edition
    article = Article.new(:edition => nil)
    article.valid?
    assert_equal "can't be blank", article.errors[:edition]
  end
  
  def test_should_validate_associated_edition
    edition = Edition.new
    edition.stubs(:valid?).returns(false)
    article = Article.new(:edition => edition)
    article.valid?
    assert_equal "is invalid", article.errors[:edition]
  end
  
  def test_should_find_recent_articles
    Article.expects(:find).with(:all, :include => [:edition], :limit => 10, :order => 'editions.published_on asc')
    Article.find_recent
  end
  
  def test_should_construct_url_friendly_title
    flunk
  end
  
end