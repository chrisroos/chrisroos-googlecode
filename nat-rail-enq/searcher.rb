require 'net/http'

now = Time.now
day, month, hour, minute = now.day, now.strftime('%B'), now.hour, now.min + 2
from, to = 'ramsgate', 'london+victoria'

host = 'http://ojp.nationalrail.co.uk'
path = ['en', 'pj', 'jp'].join('/')
query_string = {
  'referer' => 'kb_homepage', # REQUIRED
  'from.searchTerm' => from,
  'to.searchTerm' => to,
  'timeOfOutwardJourney.day' => day,
  'timeOfOutwardJourney.month' => month,
  'timeOfOutwardJourney.hour' => hour,
  'timeOfOutwardJourney.minute' => minute,
  # 'IsJavaScriptEnabled' => 'true', # NOT REQUIRED
  # 'via.searchTerm' => '', # NOT REQUIRED
  # 'hidYear' => '', # NOT REQUIRED
  # 'timeOfOutwardJourney.arrivalOrDeparture' => 'DEPART', # NOT REQUIRED
  # 'timeOfOutwardJourney.firstOrLast' => 'FIRST', # NOT REQUIRED
  # 'timeOfReturnJourney.day' => '', # NOT REQUIRED
  # 'timeOfReturnJourney.month' => '', # NOT REQUIRED
  # 'timeOfReturnJourney.hour' => '23', # NOT REQUIRED
  # 'timeOfReturnJourney.minute' => '15', # NOT REQUIRED
  # 'timeOfReturnJourney.arrivalOrDeparture' => 'DEPART', # NOT REQUIRED
  # 'timeOfReturnJourney.firstOrLast' => 'FIRST', # NOT REQUIRED
  # 'maxChanges' => '-1', # NOT REQUIRED
  # 'planjourney' => 'SEARCH' # NOT REQUIRED
}.to_a.collect { |key_and_value| key_and_value.join('=') }.join('&')

uri = URI.parse [[host, path].join('/'), query_string].join('?')
cookie, location = Net::HTTP.start(uri.host, uri.port) do |http|
  response = http.get(uri.request_uri)
  [response['set-cookie'], response['Location']]
end

uri = URI.parse(location)
html = Net::HTTP.start(uri.host, uri.port) do |http|
  http.get(uri.request_uri, 'Cookie' => cookie)
end

File.open('blurgh1.html', 'w') { |f| f.puts(html) }