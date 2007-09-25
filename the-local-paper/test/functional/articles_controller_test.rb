require File.dirname(__FILE__) + '/../test_helper'
require 'articles_controller'

class ArticlesControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = ArticlesController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_should_route_the_root_of_the_site_to_list_of_recent_articles
    assert_routing '/', :controller => 'articles', :action => 'list'
  end
  
  def test_should_include_site_wide_stylesheet
    get :list
    assert_select "link[rel=stylesheet][href=/stylesheets/application.css]"
  end
  
  def test_should_link_to_the_permalink_of_the_article
    flunk
  end
  
  def test_should_html_escape_the_article_title
    title = "Title & Ampersand"
    article = Article.new(:title => title)
    Article.stubs(:find_recent).returns([article])
    get :list
    assert_select 'ul.articles > li.article > a', ERB::Util::html_escape(title)
  end
  
  def test_should_not_display_any_articles
    get :list
    assert_select 'ul.articles', false
  end
  
  def test_should_route_to_the_permalink_of_the_article
    expected_options = {
      :controller => 'articles', :action => 'show', 
      :paper_title => 'paper-title', :edition_label => 'edition-label', :page_number => 'page-number',
      :article_title => 'article-title'
    }
    assert_routing '/paper-title/edition-label/page-number/article-title', expected_options
  end
  
  def test_should_show_the_article
    flunk
  end
  
end