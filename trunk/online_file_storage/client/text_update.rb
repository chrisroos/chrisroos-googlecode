#!/usr/bin/env ruby

content_id = ARGV.shift
raise "Must supply id of content to update" unless content_id
debug = ARGV.shift

body = ''
while line = gets
  body << line
end
raise "Body is required" unless body

require 'net/http'

xml = %Q[
<?xml version="1.0" encoding="UTF-8"?>
<content>
  <body>#{body}</body>
</content>
]

http = Net::HTTP.new('localhost', '3000')
response = http.put("/contents/#{content_id}", xml, 'Content-Type' => 'text/xml', 'Accept' => 'text/xml')

if response.code == '404'
  puts "You are trying to update a resource that no longer exists.  Please find and enter the correct Id of the resource you wish to update."
elsif response.code != '200'
  puts "Unable to update your data (http status #{response.code}), please try again."
  puts response if debug
end