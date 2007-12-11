require 'mongrel'
require 'nat-rail-enq'

port = ENV['NAT_RAIL_ENQ_SERVER_PORT'] || 4000

class SimpleHandler < Mongrel::HttpHandler
  def process(request, response)
    raw_query = request.params['QUERY_STRING']
    query = raw_query.split('&').inject({}) { |hash, key_value_pair| key, value = key_value_pair.split('=').collect { |cgi_escaped_value| CGI.unescape(cgi_escaped_value)}; hash[key] = value; hash } rescue {}
    
    response.start do |head, out|
      if query['from'] && query['to']
        time = one_minute_from_now = Time.now + (1 * 60)
        
        month = time.strftime("%B")
        day = time.strftime("%d")
        hour = time.strftime("%H")
        minute = time.strftime("%M")
        
        parameters = NationalRailEnquiries::Parameters.new(query['from'], query['to'], day, month, hour, minute)
        out << NationalRailEnquiries.search(parameters)
      else
        out << "Please specify from and to station names"
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