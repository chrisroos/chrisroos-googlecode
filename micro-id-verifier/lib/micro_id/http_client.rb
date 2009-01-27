require 'net/http'

class HttpClient
  
  def http_headers
    { 
      'User-Agent' => 'MicroID verifier',
      'From' => 'you@yoursite.com'
    }
  end
  
  def get_html(url, net_http_class = Net::HTTP)
    host, port, path = host_port_and_path(url)
    http = net_http_class.new(host, port)
    http.get(path, http_headers).body
  end
  
  def host_port_and_path(url)
    uri = URI.parse(url)
    [uri.host, uri.port, uri.path]
  end
  
end