#!/usr/bin/env ruby

require 'net/http'

content_id = ARGV.shift
raise "Must supply id of text to get" unless content_id
debug = ARGV.shift

http = Net::HTTP.new('localhost', '3000')
request = Net::HTTP::Delete.new("/contents/#{content_id}", 'Accept' => 'text/xml')
request.basic_auth 'chris', 'password'
response = http.request(request)

if response.code == '200'
  puts "Deleted resource with id of #{content_id}"
else
  puts "Unable to delete your data (http status #{response.code}), please try again."
  puts response if debug
end