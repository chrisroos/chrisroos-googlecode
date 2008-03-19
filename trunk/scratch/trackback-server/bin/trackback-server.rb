DATA_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'data')
TEMPLATE_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'templates')

require 'rubygems'
require 'mongrel'
require File.join(File.dirname(__FILE__), '..', 'lib', 'trackback_http_request')
require File.join(File.dirname(__FILE__), '..', 'lib', 'trackback_renderer')
require File.join(File.dirname(__FILE__), '..', 'lib', 'trackbacks')
require File.join(File.dirname(__FILE__), '..', 'lib', 'erb_renderer')

class TrackbackListHandler < Mongrel::HttpHandler
  def process(request, response)
    trackbacks = Trackbacks.find_all
    response.start do |head, out|
      head['Content-Type'] = 'text/html'
      template = File.join(TEMPLATE_DIRECTORY, 'trackbacks.html.erb')
      ErbRenderer.new(template, binding).render(out)
    end
  end
end

class TrackbackHandler < Mongrel::HttpHandler
  def process(request, response)
    trackback_http_request = TrackbackHttpRequest.new(request)

    if trackback_http_request.valid?
      data = trackback_http_request.trackback.to_hash
      Trackbacks.create(data)
      template = File.join(TEMPLATE_DIRECTORY, 'trackback_success.xml.erb')
    else
      template = File.join(TEMPLATE_DIRECTORY, 'trackback_failure.xml.erb')
    end
    
    response.start do |head, out|
      ErbRenderer.new(template, binding).render(out)
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