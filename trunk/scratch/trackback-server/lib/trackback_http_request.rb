require File.join(File.dirname(__FILE__), 'trackback_http_request_http_method')
require File.join(File.dirname(__FILE__), 'trackback_http_request_http_content_type')
require File.join(File.dirname(__FILE__), 'trackback_http_request_trackback')

class TrackbackHttpRequest
  
  attr_reader :trackback
  
  def initialize(http_request)
    @http_method = HttpMethod.new(http_request.params)
    @http_content_type = HttpContentType.new(http_request.params)
    @trackback = Trackback.from_http_request(http_request)
  end
  
  def valid?
    @http_method.valid? && @http_content_type.valid? && @trackback.valid?
  end
  
  def errors
    [@http_method.error, @http_content_type.error, @trackback.error].compact
  end
  
end