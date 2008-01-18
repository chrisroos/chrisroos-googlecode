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

require 'active_record'

ActiveRecord::Base.establish_connection({
  :adapter => 'mysql',
  :host => 'localhost',
  :database => 'blog_seagul_co_uk',
  :user => 'root'
})

class Article < ActiveRecord::Base; end
class Trackback < ActiveRecord::Base; end
class Comment < ActiveRecord::Base; end
class Page < ActiveRecord::Base; end