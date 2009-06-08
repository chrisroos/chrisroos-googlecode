require 'net/http'

class DomainUrlNormaliser
  
  def self.normalise(domain)
    new(domain.domain).url
  end

  attr_reader :url
  def initialize(url)
    @url = url
    prepend_missing_http!
    append_missing_slash!
    canonicalise_url!
  end
  
  def canonical_url(url)
    uri = URI.parse(url)
    response = Net::HTTP.start(uri.host) do |http|
      http.request_head('/')
    end
    
    case response.code
    when '200'     then url
    when '301'     then canonical_url(response['location'])
    when '302'     then url # Don't redirect www.google.com to www.google.co.uk (they do that with a 302, where they redirect google.com to www.google.com with a 301)
    else
      response.error!
    end
  end
  
private
  
  def prepend_missing_http!
    @url = 'http://' + @url unless @url =~ /^http/
  end
  
  def append_missing_slash!
    @url = @url + '/' unless @url =~ /\/$/
  end
  
  def canonicalise_url!
    @url = canonical_url(@url)
  end
  
end