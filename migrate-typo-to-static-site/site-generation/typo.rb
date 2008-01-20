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
require 'page_generator'

find_options = {}

articles = Article.find(:all, find_options)
tags = Tag.find(:all, find_options)
pages = Page.find(:all, find_options)
years = Year.find_all

PageGenerator.new(articles, :article).generate
PageGenerator.new(tags, :tag).generate
PageGenerator.new(pages, :page).generate
PageGenerator.new(years, :year).generate