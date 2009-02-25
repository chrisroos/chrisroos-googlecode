require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'json'

domain_url = ARGV.shift
raise "You must specify the domain name that you wish to download bookmarks for" unless domain_url

domain = Domain.find_by_domain(domain_url)
bookmark_file = File.join(File.dirname(__FILE__), 'bookmarks', "#{domain.domain_hash}.json")
bookmarked_urls = JSON.parse(File.read(bookmark_file))

bookmarked_urls.each do |bookmarked_url_attrs|
  url = domain.urls.find_by_url_hash(bookmarked_url_attrs['hash'])
  raise "Expected to find record for url: #{bookmarked_url_attrs['url']}" unless url
  
  url.title = bookmarked_url_attrs['title']
  url.total_posts = bookmarked_url_attrs['total_posts']
  url.top_tags = bookmarked_url_attrs['top_tags']
  url.save!
end