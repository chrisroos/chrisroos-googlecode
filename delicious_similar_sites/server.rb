require 'rubygems'
require 'mongrel'
require 'delicious'

class DeliciousHandler < Mongrel::HttpHandler
  def process(request, response)
    hash_of_url = request.params['PATH_INFO'].sub(/^\//, '')
    if hash_of_url
      site_bookmark = Delicious.bookmark_from_hash(hash_of_url)
      if site_bookmark
        rs = RelatedSites.new(site_bookmark)
        response.start do |head, out|
          head["Content-Type"] = "text/html"
          tags_html = ''
          rs.related_sites.each do |tag, bookmarks|
            next if bookmarks.empty?
            tags_html += "<h2>#{tag}</h2>"
            tags_html += '<ul>'
            bookmarks.each do |bookmark|
              tags_html += '<li>'
              tags_html += %Q[<a href="#{bookmark.url}" title="#{bookmark.title}">#{bookmark.description}</a>]
              tags_html += '</li>'
            end
            tags_html += '</ul>'
          end
          html = <<-EndHtml
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Del.icio.us tags</title>
  </head>
  <body>
    <h1>#{site_bookmark.title}</h1>
    <p>#{site_bookmark.description}</p>
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

config = Mongrel::Configurator.new :host => '127.0.0.1', :port => '4001', :pid_file => "#{File.dirname(__FILE__)}/mongrel.pid" do
  daemonize :cwd => Dir.pwd, :log_file => "#{File.dirname(__FILE__)}/mongrel.log"
  listener do
    uri "/delicious", :handler => DeliciousHandler.new
  end
  trap("INT") { stop }
  run
end

config.write_pid_file
config.join