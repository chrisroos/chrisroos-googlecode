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
require 'page_generator'

find_options = {}

articles = Article.find(:all, find_options)
tags = Tag.find(:all, find_options)
pages = Page.find(:all, find_options)

# PageGenerator.new(articles, :article).generate
# PageGenerator.new(tags, :tag).generate
# PageGenerator.new(pages, :page).generate

class Year
  attr_reader :year, :articles
  def initialize(year, articles)
    @year, @articles = year, articles
  end
  def path
    File.join(ARTICLES_URL_ROOT, @year)
  end
  def url
    File.join(path, 'index')
  end
end

Article.years_published.each do |year|
  articles = Article.find_all_published_during(year)
  year = Year.new(year, articles)
  PageGenerator.new([year], :year).generate
end