#!/usr/bin/env ruby

require 'net/http'
require 'rexml/document'

content_id = ARGV.shift
raise "Must supply id of text to get" unless content_id

http = Net::HTTP.new('localhost', '3000')
response = http.get("/contents/#{content_id}", 'Accept' => 'text/xml')
document = REXML::Document.new(response.body)

puts document.elements['/content/body'].text