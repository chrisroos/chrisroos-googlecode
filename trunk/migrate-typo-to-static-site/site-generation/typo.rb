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
require File.join(MIGRATOR_ROOT, 'erb_renderer')

Article.find(:all).each do |article|
  FileUtils.mkdir_p(article.path)
  
  template = File.join(TEMPLATE_ROOT, 'article.erb.html')
  renderer = ErbRenderer.new(template, article.binding)
  File.open("#{article.url}.html", 'w') { |io| renderer.render(io) }
end

Tag.find(:all).each do |tag|
  FileUtils.mkdir_p(tag.path)
  
  template = File.join(TEMPLATE_ROOT, 'tag.erb.html')
  renderer = ErbRenderer.new(template, tag.binding)
  File.open("#{tag.url}.html", 'w') { |io| renderer.render(io) }
end