require 'mongrel'
require 'json'

port = ENV['REDIRECTION_WEB_INTERFACE_PORT'] || '4001'

RULES_PATH = File.join(File.dirname(__FILE__), 'rules.conf')

class RedirectionsHandler < Mongrel::HttpHandler
  def process(request, response)
    r = {
      :http_method => request.params['REQUEST_METHOD'],
      :path => request.params['REQUEST_PATH'],
      :raw_data => request.body.gets
    }.freeze # This is in an attempt to catch stoopid errors, like over-writing the variables in my condition checks

    if r[:path] == '/' && r[:http_method] == 'GET'
      response.start do |head, out|
        out << File.read(RULES_PATH)
      end
    elsif r[:http_method] == 'PUT' && r[:raw_data]
      redirection = JSON.parse(r[:raw_data])
      
      if redirection['url']
      
        rules = JSON.load(File.open(RULES_PATH)) rescue {}
        rules[r[:path]] = redirection['url']
        File.open(RULES_PATH, 'w') { |file| file.puts(rules.to_json) }
    
        response.start(201) do |head, out|
          head['Location'] = '/'
        end
      else
        # ERROR - NOT ENOUGH DATA SENT TO CREATE REDIRECTION
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