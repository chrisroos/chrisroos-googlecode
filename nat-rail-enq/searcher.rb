require 'net/http'

class Searcher
  def initialize(from, to)
    @from, @to = from, to
  end
  def search_timetable
    uri = URI.parse(search_url)
    cookie, location = Net::HTTP.start(uri.host, uri.port) do |http|
      response = http.get(uri.request_uri)
      [response['set-cookie'], response['Location']]
    end
    uri = URI.parse(location)
    Net::HTTP.start(uri.host, uri.port) do |http|
      http.get(uri.request_uri, 'Cookie' => cookie)
    end
  end
  private
  def search_url
    [[host, path].join('/'), query_string].join('?')
  end
  def host
    'http://ojp.nationalrail.co.uk'
  end
  def path
    ['en', 'pj', 'jp'].join('/')
  end
  def query_string
    now = Time.now
    day, month, hour, minute = now.day, now.strftime('%B'), now.hour, now.min + 2
    {
      'referer' => 'kb_homepage',
      'from.searchTerm' => @from,
      'to.searchTerm' => @to,
      'timeOfOutwardJourney.day' => day,
      'timeOfOutwardJourney.month' => month,
      'timeOfOutwardJourney.hour' => hour,
      'timeOfOutwardJourney.minute' => minute
    }.to_a.collect { |key_and_value| key_and_value.join('=') }.join('&')
  end
end

searcher = Searcher.new('ramsgate', 'wae')
File.open('blurgh1.html', 'w') { |f| f.puts(searcher.search_timetable) }