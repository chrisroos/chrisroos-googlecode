require 'net/http'

# request_url = 'http://the-local-paper.co.uk/isle-of-thanet-gazette'
# url = URI.parse(request_url)
# 
# request = Net::HTTP::Get.new(url.path)
# response = Net::HTTP.start(url.host, url.port) do |http|
#   http.request(request)
# end
# p response['Location']

expectations = {
  'http://www.the-local-paper.co.uk/' => {
    :url => 'http://the-local-paper.co.uk/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/index.html' => {
    :url => 'http://the-local-paper.co.uk/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/isle-of-thanet-gazette/' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/isle-of-thanet-gazette/index.html' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/isle-of-thanet-gazette/2008/' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/isle-of-thanet-gazette/2008/index.html' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/index.html' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04/' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04/index.html' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04/', :code => '301'
  },
  'http://www.the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04/knives-mar-new-year.html' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04/knives-mar-new-year', :code => '301'
  },
  'http://the-local-paper.co.uk/' => {
    :code => '200'
  },
  'http://the-local-paper.co.uk/isle-of-thanet-gazette' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/',
    :code => '301'
  },
  'http://the-local-paper.co.uk/isle-of-thanet-gazette/' => {
    :code => '200'
  },
  'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/',
    :code => '301'
  },  
  'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/' => {
    :code => '200'
  },
  'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/',
    :code => '301'
  },
  'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/' => {
    :code => '200'
  },
  'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04' => {
    :url => 'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04/',
    :code => '301'
  },
  'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04/' => {
    :code => '200'
  },
  'http://the-local-paper.co.uk/isle-of-thanet-gazette/2008/01/04/knives-mar-new-year' => {
    :code => '200'
  }
}

expectations.each do |request_url, expected_attributes|
  puts "Requesting: #{request_url}"
  
  url = URI.parse(request_url)
  request = Net::HTTP::Get.new(url.path)
  response = Net::HTTP.start(url.host, url.port) do |http|
    http.request(request)
  end
  
  if redirection_url = expected_attributes[:url]
    raise "Expected '#{redirection_url}' in the Location header but got '#{response['Location']}'." unless redirection_url == response['Location']
  end
  if status_code = expected_attributes[:code]
    raise "Expected status code of (#{status_code}) but got (#{response.code})." unless status_code == response.code
  end
end