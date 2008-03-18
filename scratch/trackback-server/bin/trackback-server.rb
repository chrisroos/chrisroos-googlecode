require 'rubygems'
require 'mongrel'
require File.join(File.dirname(__FILE__), '..', 'lib', 'trackback_http_request')
require File.join(File.dirname(__FILE__), '..', 'lib', 'trackback_renderer')
require File.join(File.dirname(__FILE__), '..', 'lib', 'trackbacks')
require File.join(File.dirname(__FILE__), '..', 'lib', 'erb_renderer')

TRACKBACK_FILE = File.join(File.dirname(__FILE__), '..', 'data', 'trackbacks.yml')
unless File.exists?(TRACKBACK_FILE)
  File.open(TRACKBACK_FILE, 'w') { |f| f.puts [].to_yaml }
end

TRACKBACKS_TEMPLATE = File.join(File.dirname(__FILE__), '..', 'templates', 'trackbacks.html.erb')

class TrackbackListHandler < Mongrel::HttpHandler
  def process(request, response)
    trackbacks = Trackbacks.from_yaml_file(TRACKBACK_FILE)
    response.start do |head, out|
      head['Content-Type'] = 'text/html'
      ErbRenderer.new(TRACKBACKS_TEMPLATE, binding).render(out)
    end
  end
end

class TrackbackHandler < Mongrel::HttpHandler
  def process(request, response)
    trackback_http_request = TrackbackHttpRequest.new(request)

    if trackback_http_request.valid?
      data = trackback_http_request.trackback.to_hash
      trackbacks = Trackbacks.from_yaml_file(TRACKBACK_FILE)
      trackbacks.add(data)
      trackbacks.to_yaml_file(TRACKBACK_FILE)

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
  <message>#{trackback_http_request.errors.join(', ')}</message> 
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
    uri '/trackback', :handler => TrackbackHandler.new
    uri '/', :handler => TrackbackListHandler.new
  end
  trap("INT") { stop }
  run
end

config.join