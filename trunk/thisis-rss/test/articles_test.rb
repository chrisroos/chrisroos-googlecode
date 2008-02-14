require File.join(File.dirname(__FILE__), 'test_helper')
require 'articles'

class ArticlesTest < Test::Unit::TestCase
  
  def test_should_not_add_duplicate_articles
    article = {:id => 'unique-article-id'}
    articles = Articles.new
    articles.add(article)
    articles.add(article)
    
    assert_equal 1, articles.length
  end
  
  def test_should_iterate_over_articles
    article_1, article_2 = {:id => 1}, {:id => 2}
    articles = Articles.new
    articles.add(article_1)
    articles.add(article_2)
    collected_articles = []
    articles.each { |a| collected_articles << a }
    
    assert collected_articles.include?(article_1)
    assert collected_articles.include?(article_2)
  end
  
  def test_should_return_false_when_a_duplicate_article_is_added_so_that_we_can_know_to_stop_processing_html_pages_that_we_have_previously_seend
    article = {:id => 'unique-article-id'}
    articles = Articles.new
    articles.add(article)
    assert_equal false, articles.add(article)
  end
  
  def test_should_not_return_false_when_an_article_is_successfully_added
    article = {:id => 'unique-article-id'}
    articles = Articles.new
    assert_not_equal false, articles.add(article)
  end
  
end