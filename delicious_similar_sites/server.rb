require 'rubygems'
require 'mongrel'
require 'erb'
require 'delicious'

class DeliciousHandler < Mongrel::HttpHandler
  def process(request, response)
    hash_of_url = request.params['PATH_INFO'].sub(/^\//, '')
    if hash_of_url
      site_bookmark = Delicious.bookmark_from_hash(hash_of_url)
      if site_bookmark
        bookmarks = Bookmarks.similar_to(site_bookmark)
        response.start do |head, out|
          head["Content-Type"] = "text/html"
          template = File.open('related-sites.erb') { |f| f.read }
          erb = ERB.new(template)
          out << erb.result(bookmarks.__send__(:binding))
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
  # daemonize :cwd => Dir.pwd, :log_file => "#{File.dirname(__FILE__)}/mongrel.log"
  listener do
    uri "/delicious", :handler => DeliciousHandler.new
  end
  trap("INT") { stop }
  run
end

config.write_pid_file
config.join