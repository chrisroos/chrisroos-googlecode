#! /usr/bin/env ruby

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

require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'article'
require 'page'
require File.join(File.dirname(__FILE__), '..', 'site-generation', 'views')
require 'page_generator'

latest_articles = Article.find_all[0...10]

latest_articles_view = LatestArticlesView.new(latest_articles)
PageGenerator.new(latest_articles_view, 'articles').generate

latest_articles_xml_view = LatestArticlesXmlView.new(latest_articles)
PageGenerator.new(latest_articles_xml_view, 'articles', 'xml').generate

Page.find_all.each do |page|
  view = PageView.new(page)
  PageGenerator.new(view, 'page').generate
end

articles = Article.find_all

articles.each do |article|
  view = ArticleView.new(article)
  PageGenerator.new(view, 'article').generate
end

articles_view = ContentsView.new(articles)
PageGenerator.new(articles_view, 'contents').generate

view = SitemapView.new(articles)
PageGenerator.new(view, 'sitemap', 'xml').generate
