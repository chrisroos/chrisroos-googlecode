require 'builder'
require File.join(File.dirname(__FILE__), *%w[.. lib swimming_pools])

sitemap_buffer = StringIO.new

builder = Builder::XmlMarkup.new(:target => sitemap_buffer, :indent => 2)
builder.instruct!
builder.urlset(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
  builder.url do
    builder.loc 'http://public-swimming-pools.co.uk/swimming-pools.kml'
  end
  # SwimmingPools.find_all.each do |swimming_pool|
  #   builder.url do 
  #     builder.loc "http://public-swimming-pools.co.uk/#{swimming_pool.permalink}"
  #   end
  # end
end

File.open(File.join(File.dirname(__FILE__), *%w[.. public sitemap.xml]), 'w') { |f| f.puts(sitemap_buffer.string) }