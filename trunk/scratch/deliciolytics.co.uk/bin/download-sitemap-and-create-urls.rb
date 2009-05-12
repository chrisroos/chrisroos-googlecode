require File.join(File.dirname(__FILE__), '..', 'config', 'environment.rb')
require 'net/http'

domain_url = ARGV.shift
raise "You must specify the url of the domain that you wish to download bookmarks for" unless domain_url

sitemap_file = ARGV.shift

if sitemap_file
  sitemap = File.read(sitemap_file)
else
  sitemap_url = "#{domain_url}/sitemap.xml"
  sitemap = Net::HTTP.get(URI.parse(sitemap_url))
end
urls = sitemap.scan(/<loc>(.*?)<\/loc>/).flatten

domain = Domain.find_or_create_by_domain(domain_url)
urls.each do |url|
  domain.urls.create!(:url => url)
end