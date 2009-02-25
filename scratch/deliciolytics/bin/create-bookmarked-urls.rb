require File.join(File.dirname(__FILE__), 'config', 'environment')

require 'json'

bookmarked_urls = JSON.parse(File.read('bookmarked_urls.json'))

bookmarked_urls.each do |bookmarked_url_attrs|
  bookmarked_url_attrs['url_hash'] = bookmarked_url_attrs.delete('hash')
  Url.create!(bookmarked_url_attrs)
end