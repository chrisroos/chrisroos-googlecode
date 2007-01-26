#!/usr/bin/env ruby

require 'net/http'

content_id = ARGV.shift
raise "Must supply id of text to get" unless content_id
debug = ARGV.shift

http = Net::HTTP.new('localhost', '3000')
response = http.delete("/contents/#{content_id}", 'Accept' => 'text/xml')

if response.code == '200'
  puts "Deleted resource with id of #{content_id}"
else
  puts "Unable to delete your data (http status #{response.code}), please try again."
  puts response if debug
end