require File.join(File.dirname(__FILE__), 'trackback_http_request_http_method')
require File.join(File.dirname(__FILE__), 'trackback_http_request_http_content_type')

class TrackbackHttpRequest
  
  def initialize(http_request)
    @http_method = HttpMethod.new(http_request.params)
    @http_content_type = HttpContentType.new(http_request.params)
  end
  
  def valid?
    @http_method.valid? && @http_content_type.valid?
  end
  
  def errors
    [@http_method.error, @http_content_type.error].compact
  end
  
end