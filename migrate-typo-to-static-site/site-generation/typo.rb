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
require 'views'
require 'page_generator'

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

latest_articles_xml_view = LatestArticlesXmlView.new(articles)
PageGenerator.new(latest_articles_xml_view, 'articles', 'xml').generate

Page.find(:all).each do |page|
  view = PageView.new(page)
  PageGenerator.new(view, 'page').generate
end

Article.find(:all).each do |article|
  view = ArticleView.new(article)
  PageGenerator.new(view, 'article').generate
end

articles = Article.find(:all, :order => 'published_at DESC')
articles_view = ContentsView.new(articles)
PageGenerator.new(articles_view, 'contents').generate