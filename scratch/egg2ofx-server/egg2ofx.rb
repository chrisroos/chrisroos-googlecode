require 'rubygems'
require 'sinatra'

$: << File.join(File.dirname(__FILE__), 'vendor', 'egg2ofx', 'lib')
require 'egg.rb'

# TODO - host this app somewhere on the interwebs

get '/' do
  "<h1>egg2ofx</h1>" # TODO - add a nice little introduction page thing
end

# TODO - add a manual upload page

post '/' do  
  content_type 'text/ofx' # TODO - what is the correct value here?
  attachment 'egg-statement.ofx'

  html = params['documentHtml']
  begin
    parser = Egg::Parser.new(html)
    parser.to_ofx
  rescue Egg::Parser::UnparsableHtmlError
    error "Well, that didn't work, did it."
  end
end