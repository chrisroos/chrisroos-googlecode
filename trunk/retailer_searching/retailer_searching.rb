require 'rubygems'
require 'hpricot'

amazon_html = open('/users/chrisroos/desktop/retailer_searching/amazon.html').read
doc = Hpricot(amazon_html)
doc.search("//td[@class='dataColumn']") do |td|
  name = td.search("//span[@class='srTitle']")
  price = td.search("//span[@class='sr_price']").text
  price = td.search("//span[@class='listprice]").text if price.empty?
  price = td.search("//span[@class='saleprice]").text if price.empty?
  price = 'N/A' if price.empty?
  p [name.text, price]
end