require 'rubygems'
require 'mongrel'

class TrackbackHandler < Mongrel::HttpHandler
  def process(request, response)
    # request should be POST
    # body of request should look like..
    # e.g. title=Foo+Bar&url=http://www.bar.com/&excerpt=My+Excerpt&blog_name=Foo
    http_method = request.params['REQUEST_METHOD']
    unless http_method == 'POST'
      error = "You must use HTTP POST, you used: #{http_method.inspect}"
    end
    
    content_type = request.params['HTTP_CONTENT_TYPE']
    unless content_type =~ /^application\/x-www-form-urlencoded/
      error = "You must specify the Content-Type header as application/x-www-form-urlencoded.  You specified: #{content_type.inspect}"
    end
    
p request
p request.body.read#.string
    if !error # good
      xml_response = <<-EndXml
<?xml version="1.0" encoding="utf-8"?>
<response>
  <error>0</error>
</response>
EndXml
    else
      xml_response = <<-EndXml
<?xml version="1.0" encoding="utf-8"?> 
<response> 
  <error>1</error> 
  <message>#{error}</message> 
</response>
      EndXml
    end
    
    response.start do |head, out|
      out << xml_response
    end
  end
end

config = Mongrel::Configurator.new :host => '127.0.0.1', :port => '4000' do
  listener do
    uri "/", :handler => TrackbackHandler.new
  end
  trap("INT") { stop }
  run
end

config.join