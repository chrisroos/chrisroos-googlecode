require 'mongrel'
require 'redirector'
require 'configuration_loader'

port = ENV['REDIRECTION_PORT'] || '4000'

class SimpleHandler < Mongrel::HttpHandler
  def process(request, response)
    configuration_loader = ConfigurationLoader.new(request)
    rules = configuration_loader.load_rules
    redirector = Redirector.new(request, rules)
    
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