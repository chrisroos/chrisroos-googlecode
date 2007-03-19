require 'uri'

class UriSanitizer
  
  def initialize(uri)
    @uri = URI.parse(uri)
  end
  
  def path
    @uri.path.sub(/\/$/, '')
  end
  
  def querystring
    @uri.query ? ('?' + @uri.query) : ''
  end
  
  def location
    path + querystring
  end
  
end