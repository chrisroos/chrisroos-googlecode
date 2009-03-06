require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require File.join(File.dirname(__FILE__), 'active_places_helper')
include ActivePlacesHelper

# We don't care about the output, we just need the cookie
`curl "http://activeplaces.com/Index_lowgraphic.asp" -c"#{ACTIVE_PLACES_COOKIE_FILE}" -A"http://chrisroos.co.uk"`

postcode = 'ct11'
distance = 50

search_result_html = `curl "http://activeplaces.com/FindNearest/SearchResults_LowGraphic.asp?qsPostCode=#{postcode}&qsFacTyp=ALL&qsFacSubTyp=ALL&qsDistance=#{distance}" -b"#{ACTIVE_PLACES_COOKIE_FILE}"`
search_result_html_file = File.join(Rails.root, 'data', "search-results-#{postcode}-all.html")
create_file_with_metadata(search_result_html_file, search_result_html)