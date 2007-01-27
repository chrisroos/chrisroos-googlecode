#!/usr/bin/env ruby

# *** COULD JUST GET IN TEXT FORMAT FOR THIS

require 'net/http'
require 'rexml/document'

content_id = ARGV.shift
raise "Must supply id of text to get" unless content_id
debug = ARGV.shift

http = Net::HTTP.new('localhost', '3000')
request = Net::HTTP::Get.new("/contents/#{content_id}", 'Accept' => 'text/xml')
request.basic_auth 'chris', 'password'
response = http.request(request)

if response.code == '200'
  # No informational message as we may wish to pipe straight into another program
  document = REXML::Document.new(response.body)
  puts document.elements['/content/body'].text
elsif response.code == '404'
  puts "You are trying to retrieve a resource that no longer exists.  Please find and enter the correct Id of the resource you wish to update."
else
  puts "Unable to retrieve your data (http status #{response.code}), please try again."
  puts response if debug
end