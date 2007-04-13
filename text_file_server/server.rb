#! /usr/bin/env ruby

require 'rubygems'
require 'mongrel'

Server = {
  :host => '127.0.0.1',
  :port => '3001'
}
FilesPath = File.dirname(__FILE__) + '/files/'

Dir.mkdir(FilesPath) unless File.exists?(FilesPath)

class FileHandler < Mongrel::HttpHandler
  def process(request, response)
    method = request.params['REQUEST_METHOD'].downcase.to_sym
    content_type = (request.params['HTTP_CONTENT_TYPE'] || '').downcase if method == :post
    content_length = Integer(request.params['CONTENT_LENGTH']) if method == :post
    if method == :post
      if content_length == 0
        response.start(400) { |head, out| out.puts('You gotta submit a text file eh.') }
      elsif content_length > 5000
        response.start(413) { |head, out| out.puts('Text files submitted to the server can have a maximum size of 5KB.') }
      elsif content_type != 'text/plain'
        response.start(415) { |head, out| out.puts('Content-Type must be text/plain.') }
      else
        filename = Time.now.to_i.to_s
        File.open(FilesPath + filename, 'w') { |file| file.puts(request.body.read) }
        response.start(201) { |head, out| head['Location'] = "http://#{Server[:host]}:#{Server[:port]}/" + 'files/' + filename }
      end
    elsif method == :delete
      filename = request.params['PATH_INFO']
      if File.exists?(FilesPath + filename)
        response.start(200) do |head, out|
          head['Content-Type'] = 'text/plain'
          out.puts(File.open(FilesPath + filename).read)
        end
        File.delete(FilesPath + filename)
      else
        response.start(404) { |head, out| out.puts('NOT FOUND') }
      end
    else
      response.start(405) { |head, out| head['Allow'] = 'POST, DELETE' }
    end
  end
end

config = Mongrel::Configurator.new(:host => Server[:host], :port => Server[:port]) do
  listener do
    uri "/files", :handler => FileHandler.new
  end
  trap("INT") { stop }
  run
end

puts "Mongrel running on #{ARGV[0]}:#{ARGV[1]} with docroot #{ARGV[2]}"
config.join