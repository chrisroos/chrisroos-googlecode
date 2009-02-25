require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require 'md5'
require 'json'
require 'net/http'

domain = Domain.find(:first)

bookmarked_urls = domain.urls.collect do |url|
  puts "Collecting URL history for: #{url.url}"
  json = Net::HTTP.get(URI.parse("http://feeds.delicious.com/v2/json/urlinfo/#{url.url_hash}"))
  sleep 1
  JSON.parse(json).first
end.compact
File.open('bookmarked_urls.json', 'w') { |f| f.puts(bookmarked_urls.to_json) }