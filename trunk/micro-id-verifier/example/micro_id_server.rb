require 'webrick' 
require 'stringio'

class MicroIdServer
  
  include WEBrick
  
  attr_reader :micro_id_server
  def initialize
    server_options = { :Port => 7000, :DocumentRoot => "#{File.dirname(__FILE__)}/example_micro_id.htm", :AccessLog => StringIO.new }
    @micro_id_server = HTTPServer.new(server_options)
  end
  
  def start
    Thread.new { micro_id_server.start }
    sleep 0.1
  end
  
  def stop
    micro_id_server.stop
  end
  
end