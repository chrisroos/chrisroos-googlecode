require 'test/unit'
require 'lib/articles'

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
  
end