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
      if posts.length == 1
        post = posts.first
        response.start do |head, out|
          head["Content-Type"] = "text/html"
          list_items = post['t'].inject('') { |str, tag| str += %Q[<li><a href="http://del.icio.us/chrisjroos/#{tag}">#{tag}</a></li>] }
          html = <<-EndHtml
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
  <head>
    <title>Del.icio.us tags</title>
  </head>
  <body>
    <h1>#{post['d']}</h1>
    <p>#{post['n']}</p>
    <ul>
      #{list_items}
    </ul>
  </body>
</html>
          EndHtml
          out << html
        end
      else
        response.start(404) do |head,out|
          out << "You haven't bookmarked this url\n"
        end
      end
    else
      response.start(404) do |head,out|
        out << "Please specify the md5 hash of the url you wish to find\n"
      end
    end
  end
end

config = Mongrel::Configurator.new :host => '127.0.0.1', :port => '4001' do
  listener do
    uri "/delicious", :handler => DeliciousHandler.new
  end
  trap("INT") { stop }
  run
end

config.join