require 'rubygems'
require 'sinatra'
require '/Users/chrisroos/Code/personal/chrisroos/banking-scripts/egg2ofx/lib/egg.rb'

# TODO - rename this to egg2ofx-server

# TODO - work out a nice way of including the egg library.  i could vendorise it or create a gem from it and use gembundler or summit
#      - REMEMBER TO DO THE SIMPLEST THING TO START WITH - probably just svn:externals
# TODO - host this app somewhere on the interwebs

get '/' do
  "<h1>egg2ofx</h1>" # TODO - add a nice little introduction page thing
end

# TODO - add a manual upload page

post '/' do  
  content_type 'text/ofx' # TODO - what is the correct value here?
  attachment 'statement.ofx'

  html = params['documentHtml']
  begin
    parser = Egg::Parser.new(html)
    parser.to_ofx
  rescue Egg::Parser::UnparsableHtmlError
    error "Well, that didn't work, did it."
  end
end