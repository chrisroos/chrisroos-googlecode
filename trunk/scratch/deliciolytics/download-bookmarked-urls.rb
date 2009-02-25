require 'rubygems'
require 'md5'
require 'json'
require 'net/http'

sitemap_url = 'http://chrisroos.local/sitemap.xml'
sitemap = Net::HTTP.get(URI.parse(sitemap_url))
urls = sitemap.scan(/<loc>(.*?)<\/loc>/).flatten
hashed_urls = urls.inject({}) { |h, url| h[url] = MD5.md5(url); h }
bookmarked_urls = hashed_urls.collect do |url, url_md5|
  puts "Collecting URL history for: #{url}"
  json = Net::HTTP.get(URI.parse("http://feeds.delicious.com/v2/json/urlinfo/#{url_md5}"))
  sleep 1
  JSON.parse(json).first
end.compact
File.open('bookmarked_urls.json', 'w') { |f| f.puts(bookmarked_urls.to_json) }