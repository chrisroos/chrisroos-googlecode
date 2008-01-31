require 'rubygems'
require 'mongrel'

class TrackbackHandler < Mongrel::HttpHandler
  def process(request, response)
    # request should be POST
    # body of request should look like..
    # e.g. title=Foo+Bar&url=http://www.bar.com/&excerpt=My+Excerpt&blog_name=Foo
p request
p request.body.read#.string
    if true # good
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
  <message>The error message</message> 
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