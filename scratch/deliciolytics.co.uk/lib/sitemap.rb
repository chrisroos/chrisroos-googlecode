require 'net/http'
require 'hpricot'

class Sitemap
  def initialize(domain)
    @sitemap_url = "#{domain}sitemap.xml"
    @urls        = []
  end
  def urls
    sitemap = get_sitemap_xml(@sitemap_url)
    if (sitemap/:sitemapindex).length > 0
      (sitemap/:sitemapindex/:sitemap/:loc).each do |sitemap_location_element|
        sitemap_x = get_sitemap_xml(sitemap_location_element.inner_text)
        (sitemap_x/:urlset/:url/:loc).each do |resource_location_element|
          @urls << resource_location_element.inner_text
        end
      end
    else
      (sitemap/:urlset/:url/:loc).each do |resource_location_element|
        @urls << resource_location_element.inner_text
      end
    end
    @urls
  end
private
  def get_sitemap_xml(url)
    Hpricot.XML(get_sitemap(url))
  end
  def get_sitemap(url)
    Net::HTTP.get(URI.parse(url))
  end
end