require 'mongrel'
require 'redirector'

port = ENV['REDIRECTION_PORT'] || '4000'

HOST_AND_PATH_REDIRECTIONS = {
  'chrisroos.co.uk' => {
    '/amazonwishlist' => 'http://www.amazon.co.uk/gp/registry/IO9HVNCPEWGD'
  }
}
HOST_REDIRECTIONS = {
  'www.chrisroos.co.uk' => 'chrisroos.co.uk'
}

class SimpleHandler < Mongrel::HttpHandler
  def process(request, response)
    redirector = Redirector.new(request, HOST_REDIRECTIONS, HOST_AND_PATH_REDIRECTIONS)
    
    if redirect_to = redirector.redirect_to
      response.start(302) do |head,out|
        head["Location"] = redirect_to
      end
    else
      response.start do |head,out|
        head["Content-Type"] = "text/html"
        results = "<html><body>Your request:<br /><pre>#{request.params.to_yaml}</pre><a href=\"/files\">View the files.</a></body></html>"
        out << results
      end
    end
  end
end

config = Mongrel::Configurator.new :host => '127.0.0.1', :port => port do
  listener do
    uri "/", :handler => SimpleHandler.new
  end

  trap("INT") { stop }
  run
end

config.join

__END__
SERVER_NAME: localhost
PATH_INFO: /bar/baz
HTTP_X_FORWARDED_HOST: foo.com
HTTP_USER_AGENT: curl/7.13.1 (powerpc-apple-darwin8.0) libcurl/7.13.1 OpenSSL/0.9.7l zlib/1.2.3
SCRIPT_NAME: /
SERVER_PROTOCOL: HTTP/1.1
HTTP_HOST: localhost:4000
REMOTE_ADDR: 127.0.0.1
SERVER_SOFTWARE: Mongrel 1.0.1
REQUEST_PATH: /bar/baz
HTTP_VERSION: HTTP/1.1
HTTP_X_FORWARDED_SERVER: foo.com
REQUEST_URI: /bar/baz?q=123
SERVER_PORT: "4000"
GATEWAY_INTERFACE: CGI/1.2
HTTP_PRAGMA: no-cache
QUERY_STRING: q=123
HTTP_X_FORWARDED_FOR: 127.0.0.1
HTTP_ACCEPT: "*/*"
HTTP_CONNECTION: close
REQUEST_METHOD: GET