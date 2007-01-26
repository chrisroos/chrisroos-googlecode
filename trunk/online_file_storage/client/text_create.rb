#!/usr/bin/env ruby

title = ARGV.shift
raise "Title is required" unless title
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
  <title>#{title}</title>
  <body>#{body}</body>
</content>
]

http = Net::HTTP.new('localhost', '3000')
response = http.post('/contents', xml, 'Content-Type' => 'text/xml', 'Accept' => 'text/xml')

if response.code == '201'
  location = response.header['Location']
  puts "Your content was successfully stored (at #{location})."
else
  puts "Unable to store your data (http status #{response.code}), please try again."
  puts response if debug
end