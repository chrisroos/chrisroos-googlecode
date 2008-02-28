# Parse the example departures file for departure information

require 'rubygems'
require 'hpricot'
require 'htmlentities'

html = File.open('example-departures.html') { |f| f.read }
doc = Hpricot(html)

html_entities_decoder = HTMLEntities.new

Departures = []

(doc/'table.arrivaltable'/'tbody'/'tr').each do |table_row_element|
  destination = html_entities_decoder.decode((table_row_element/'td[1]').first.inner_text)
  platform = html_entities_decoder.decode((table_row_element/'td[2]').first.inner_text)
  departure_time = html_entities_decoder.decode((table_row_element/'td[3]').first.inner_text)
  expected = html_entities_decoder.decode((table_row_element/'td[4]').first.inner_text)
  Departures << {
    :destination => destination,
    :platform => platform,
    :departure_time => departure_time,
    :expected => expected
  }
end