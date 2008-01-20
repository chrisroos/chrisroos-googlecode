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
require File.join(MIGRATOR_ROOT, 'article')

Article.find(:all).each do |article|
  FileUtils.mkdir_p(article.path)

  require 'erb'
  include ERB::Util

  article_template = File.open('article.erb.html') { |f| f.read }
  article_erb = ERB.new(article_template)
  File.open(File.join(article.path, "#{article.permalink}.html"), 'w') do |file|
    file.puts article_erb.result(article.binding)
  end
  
end

Tag.find(:all).each do |tag|
  FileUtils.mkdir_p(tag.path)
  
  require 'erb'
  include ERB::Util

  tag_template = File.open('tag.erb.html') { |f| f.read }
  tag_erb = ERB.new(tag_template)
  File.open(File.join(tag.path, "#{tag.name}.html"), 'w') do |file|
    file.puts tag_erb.result(tag.binding)
  end
end