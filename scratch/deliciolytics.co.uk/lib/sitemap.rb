require 'net/http'

class Sitemap
  def initialize(domain)
    @sitemap_url = "#{domain}sitemap.xml"
  end
  def urls
    @urls ||= sitemap.scan(/<loc>(.*?)<\/loc>/).flatten
  end
private
  def sitemap
    @sitemap = Net::HTTP.get(URI.parse(@sitemap_url))
    if @sitemap =~ /<sitemapindex.*<sitemap.*<loc>(.*?)<\/loc>/m
      @sitemap = Net::HTTP.get(URI.parse($1))
    end
    @sitemap
  end
end