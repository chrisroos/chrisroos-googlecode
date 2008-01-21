# Useful data from discarded tables
# * Ping URLs
# http://rpc.technorati.com/rpc/ping
# http://ping.blo.gs/
# http://rpc.weblogs.com/RPC2
# * Subscribe to RSS in sidebar snippet
# <a href="http://feeds.feedburner.com/DeferredUntilInspirationHits" title="Subscribe to my feed, deferred until inspiration hits" rel="alternate" type="application/rss+xml">
# <img src="http://www.feedburner.com/fb/images/pub/feed-icon16x16.png" alt="" style="border:0"/> 
# Subscribe to the feed
# </a>

require File.join(File.dirname(__FILE__), 'environment')
require 'article'
require 'page'
require 'year'
require 'month'
require 'day'
require 'page_generator'

class ArticlesView
  def initialize(articles_container)
    @articles_container = articles_container
  end
  def path
    @articles_container.path
  end
  def url
    @articles_container.url
  end
  def articles
    @articles_container.articles
  end
  public :binding
end

class DayView < ArticlesView
  def page_title
    "Posts published on #{@articles_container.published_date.strftime("%a, %d %B %Y")}"
  end
end

class MonthView < ArticlesView
  def page_title
    "Posts published in #{@articles_container.published_date.strftime("%B %Y")}"
  end
end

class YearView < ArticlesView
  def page_title
    "Posts published in #{@articles_container.published_date.strftime("%Y")}"
  end
end

class TagView < ArticlesView
  def page_title
    "Posts tagged #{@articles_container.display_name}"
  end
end

class LatestArticlesView
  def initialize(latest_articles)
    @latest_articles = latest_articles
  end
  def path
    "/"
  end
  def url
    File.join(path, 'index')
  end
  def articles
    @latest_articles
  end
  def page_title
    "Most recent posts"
  end
  public :binding
end

class PageView
  def initialize(page)
    @page = page
  end
  def path
    @page.path
  end
  def url
    @page.url
  end
  def page_title
    @page.title
  end
  def formatted_created_date
    @page.formatted_created_date
  end
  def body_html
    @page.body_html
  end
  public :binding
end

class ArticleView
  def initialize(article)
    @article = article
  end
  def path
    @article.path
  end
  def url
    @article.url
  end
  def page_title
    @article.title
  end
  def formatted_published_date
    @article.formatted_published_date
  end
  def body_html
    @article.body_html
  end
  def tags
    @article.tags
  end
  def comments
    @article.comments
  end
  public :binding
end

Day.find_all.each do |day|
  view = DayView.new(day)
  PageGenerator.new(view, 'articles').generate
end

Month.find_all.each do |month|
  view = MonthView.new(month)
  PageGenerator.new(view, 'articles').generate
end

Year.find_all.each do |year|
  view = YearView.new(year)
  PageGenerator.new(view, 'articles').generate
end

Tag.find(:all).each do |tag|
  view = TagView.new(tag)
  PageGenerator.new(view, 'articles').generate
end

articles = Article.find(:all, :order => 'published_at DESC', :limit => 10)
latest_articles_view = LatestArticlesView.new(articles)
PageGenerator.new(latest_articles_view, 'articles').generate

Page.find(:all).each do |page|
  view = PageView.new(page)
  PageGenerator.new(view, 'page').generate
end

Article.find(:all).each do |article|
  view = ArticleView.new(article)
  PageGenerator.new(view, 'article').generate
end