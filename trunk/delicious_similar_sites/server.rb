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
          tags_html = ''
          post['t'].each do |tag|
            json_url = "http://del.icio.us/feeds/json/chrisjroos/#{tag}?raw&count=3"
            posts = JSON.parse(open(json_url).read)
            if posts.length > 0
              tags_html += "<h2>#{tag}</h2>"
              tags_html += '<ul>'
              posts.each do |post|
                tags_html += '<li>'
                tags_html += %Q[<a href="#{post['u']}" title="#{post['n']}">#{post['d']}</a>]
                tags_html += '</li>'
              end
              tags_html += '</ul>'
            end
          end
          html = <<-EndHtml
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
  <head>
    <title>Del.icio.us tags</title>
  </head>
  <body>
    <h1>#{post['d']}</h1>
    <p>#{post['n']}</p>
    #{tags_html}
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