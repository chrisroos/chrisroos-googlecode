require File.join(File.dirname(__FILE__), '..', 'config', 'environment')
require File.join(File.dirname(__FILE__), 'active_places_helper')
include ActivePlacesHelper

# We don't care about the output, we just need the cookie
`curl "http://activeplaces.com/Index_lowgraphic.asp" -c"#{ACTIVE_PLACES_COOKIE_FILE}"`

postcode = 'ct11'
facility_type = FacilityType.find(7) # swimming pools
distance = 50

search_result_html = `curl "http://activeplaces.com/FindNearest/SearchResults_LowGraphic.asp?qsPostCode=#{postcode}&qsFacTyp=#{facility_type.id}&qsFacSubTyp=ALL&qsDistance=#{distance}" -b"#{ACTIVE_PLACES_COOKIE_FILE}"`
search_result_html_file = File.join(Rails.root, 'data', "search-results-#{postcode}-#{facility_type.filename_friendly_name}.html")
create_file_with_metadata(search_result_html_file, search_result_html)