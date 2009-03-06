require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require File.join(File.dirname(__FILE__), 'active_places_helper')
include ActivePlacesHelper

# We don't care about the output, we just need the cookie
`curl "http://activeplaces.com/Index_lowgraphic.asp" -c"#{ACTIVE_PLACES_COOKIE_FILE}" -A"http://chrisroos.co.uk" -s`

postcodes = []
File.open(File.join(Rails.root, 'data', 'uk-postcode-outcodes.csv')) do |file|
  file.each_with_index do |line, index|
    next if index == 0 # ignore the first line
    postcodes << line.split(',').first
  end
end

puts "Started: #{Time.now}"
postcodes.each_with_index do |postcode, index|
  puts "Postcode (#{index}): #{postcode}"
  distance = 50
  
  cmd = %%curl "http://activeplaces.com/FindNearest/SearchResults_LowGraphic.asp?qsPostCode=#{postcode}&qsFacTyp=ALL&qsFacSubTyp=ALL&qsDistance=#{distance}" -b"#{ACTIVE_PLACES_COOKIE_FILE}" -A"http://chrisroos.co.uk" -s%
  search_result_html = `#{cmd}`
  search_result_html_file = File.join(Rails.root, 'data', "search-results-#{postcode}-all.html")
  create_file_with_metadata(search_result_html_file, search_result_html)
  
  sleep 1 # Give the server a chance to stay up
end
puts "Finished: #{Time.now}"