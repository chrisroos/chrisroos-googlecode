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
unless response.code == '201'
  puts "Unable to store your data, please try again."
  puts response if debug
end