require 'rubygems'
require 'mongrel'
require 'json'
require 'open-uri'

class DeliciousHandler < Mongrel::HttpHandler
  def process(request, response)
    url_hash = request.params['PATH_INFO'].sub(/^\//, '')
    if url_hash
      json_url = "http://del.icio.us/feeds/json/chrisjroos/url/#{url_hash}?raw"
      posts = JSON.parse(open(json_url).read)
      response.start do |head, out|
        head["Content-Type"] = "text/plain"
        out << posts.inspect
      end
    else
      response.start(404) do |head,out|
        out << "Postcode not found\n"
      end
    end
  end
end

config = Mongrel::Configurator.new :host => '127.0.0.1', :port => '4000' do
  listener do
    uri "/delicious", :handler => DeliciousHandler.new
  end
  trap("INT") { stop }
  run
end

config.join