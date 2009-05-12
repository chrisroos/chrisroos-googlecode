require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'md5'
require 'json'
require 'net/http'

domain_url = ARGV.shift
raise "You must specify the domain name that you wish to download bookmarks for" unless domain_url

domain = Domain.find_by_domain(domain_url)

bookmarked_urls = domain.urls.collect do |url|
  puts "Collecting URL history for: #{url.url}"
  json = Net::HTTP.get(URI.parse("http://feeds.delicious.com/v2/json/urlinfo/#{url.url_hash}"))
  sleep 1
  JSON.parse(json).first
end.compact

bookmark_file = File.join(File.dirname(__FILE__), 'bookmarks', "#{domain.domain_hash}.json")
File.open(bookmark_file, 'w') { |f| f.puts(bookmarked_urls.to_json) }