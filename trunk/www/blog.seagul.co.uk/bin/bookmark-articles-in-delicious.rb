require 'open-uri'
require 'hpricot'

contents = open('http://blog.seagul.local/contents')
doc = Hpricot(contents)
posts = (doc/'ol.posts/li.post').collect do |post|
  anchor = (post/'h2'/'a').first
  title = anchor.inner_text + ' - deferred until inspiration hits'
  url = 'http://blog.seagul.co.uk' + anchor.attributes['href']
  tags = (post/'p'/'a[@rel=tag]').collect { |e| e.inner_text } + ['blog.seagul.co.uk'] 

  {:title => title, :url => url, :tags => tags}
end

require 'uri'

username = 'chrisjroos'
password = '<my-password>'

## Delete all the posts as it seems adding a bookmark for an existing url doesn't change some preoperties (such as whether or not it's shared)
#posts.each do |post|
#  cmd = %%curl "https://api.del.icio.us/v1/posts/delete?url=#{URI.escape(post[:url])}" -u"#{username}:#{password}"%
#  puts cmd
#  puts `#{cmd}`
#end

# Bookmark the bastads
posts.reverse.each_with_index do |post, index| # oldest first
  cmd = %%curl "https://api.del.icio.us/v1/posts/add?url=#{URI.escape(post[:url])}&description=#{URI.escape(post[:title])}&tags=#{URI.escape(post[:tags].join(' '))}" -u"#{username}:#{password}"%
  puts cmd
  puts `#{cmd}`
  sleep 1 # Make sure the poor service can keep up with our demands
end
