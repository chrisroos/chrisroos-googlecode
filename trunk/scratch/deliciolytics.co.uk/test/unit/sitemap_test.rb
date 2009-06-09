require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'fakeweb'

class SitemapTest < Test::Unit::TestCase
  
  def test_should_parse_the_urls_from_the_sitemap
    FakeWeb.register_uri(:get, "http://example.com/sitemap.xml", :string => sitemap)
    
    sitemap = Sitemap.new('http://example.com/')
    
    assert sitemap.urls.include?('http://example.com/resource-1')
    assert sitemap.urls.include?('http://example.com/resource-2')
  end
  
  def test_should_parse_the_urls_from_the_sitemap_indicated_in_the_sitemap_index
    FakeWeb.register_uri(:get, "http://example.com/sitemap.xml", :string => sitemap_index)
    FakeWeb.register_uri(:get, "http://example.com/path/sitemap.xml", :string => sitemap)
    
    sitemap = Sitemap.new('http://example.com/')
    
    assert sitemap.urls.include?('http://example.com/resource-1')
    assert sitemap.urls.include?('http://example.com/resource-2')
  end
  
private
  
  def sitemap
<<-EndSitemap
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>http://example.com/resource-1</loc></url>
  <url><loc>http://example.com/resource-2</loc></url>
</urlset>
EndSitemap
  end
  
  def sitemap_index
<<-EndSitemapIndex
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap>
    <loc>http://example.com/path/sitemap.xml</loc>
  </sitemap>
</sitemapindex>
EndSitemapIndex
  end
  
end