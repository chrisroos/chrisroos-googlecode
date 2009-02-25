require File.join(File.dirname(__FILE__), '..', 'config', 'environment.rb')
require 'net/http'

domain_url = 'http://chrisroos.local'
sitemap_url = "#{domain_url}/sitemap.xml"

sitemap = Net::HTTP.get(URI.parse(sitemap_url))
urls = sitemap.scan(/<loc>(.*?)<\/loc>/).flatten

domain = Domain.create!(:domain => domain_url)
urls.each do |url|
  domain.urls.create!(:url => url)
end