require 'mongrel'
require 'erb'
require 'yaml'

port = ENV['REDIRECTION_WEB_INTERFACE_PORT'] || '4001'

RULES_PATH = File.join(File.dirname(__FILE__), 'rules.conf')

class RedirectionsHandler < Mongrel::HttpHandler
  def process(request, response)
    r = {
      :http_method => request.params['REQUEST_METHOD'],
      :path => request.params['REQUEST_PATH'],
      :raw_data => request.body.gets
    }.freeze # This is in an attempt to catch stoopid errors, like over-writing the variables in my condition checks
    
p r
    
    if r[:path] == '/' && r[:http_method] == 'GET'
      response.start do |head, out|
        rules = YAML.load(File.open(RULES_PATH)) || {}
        
        head["Content-Type"] = "text/html"
    
        template = File.open('list.html.erb') { |f| f.read }
        erb = ERB.new(template)
        out << erb.result(rules.__send__(:binding))
      end
    elsif r[:path] == '/new' && r[:http_method] == 'GET';
      response.start do |head, out|
        head["Content-Type"] = "text/html"
        
        template = File.open('new.html.erb') { |f| f.read }
        erb = ERB.new(template)
        out << erb.result
      end
    elsif r[:path] == '/' && r[:http_method] == 'POST' && r[:raw_data]
      # Convert (raw_data):
      # redirection_path=foo%26bar&redirection_redirect_to=http%3A%2F%2Fwww.blurgh.com%2Fwem%3Fid%3D123
      # To: (data):
      # {"redirection_path"=>"foo&bar", "redirection_redirect_to"=>"http://www.blurgh.com/wem?id=123"}
      data = r[:raw_data].split('&').inject({}) { |hash, key_value_pair| key, value = key_value_pair.split('=').collect { |cgi_escaped_value| CGI.unescape(cgi_escaped_value)}; hash[key] = value; hash }
      
      rules = YAML.load(File.open(RULES_PATH)) || {}
      rules[data['redirection_path']] = data['redirection_redirect_to']
      File.open(RULES_PATH, 'w') { |file| file.puts(rules.to_yaml) }
    
      # According to HTTP spec we should really be returning 201 with location of new resource and representation in the body
      # - I'm just not sure this is the most useful approach...
      # response.start(201) do |head, out|
      #   head['Location'] = '/'
      # end
      
      response.start(302) do |head, out|
        head['Location'] = '/'
      end
    else
      response.start(404) do |head, out|
        out << "NOT FOUND"
      end
    end
  end
end

config = Mongrel::Configurator.new :host => '127.0.0.1', :port => port do
  listener do
    uri "/", :handler => RedirectionsHandler.new
  end

  trap("INT") { stop }
  run
end

config.join