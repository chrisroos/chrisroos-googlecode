#!/usr/bin/env ruby

require 'net/http'
require 'rexml/document'

http = Net::HTTP.new('localhost', '3000')
request = Net::HTTP::Get.new('/contents', 'Accept' => 'text/xml')
request.basic_auth 'chris', 'password'
response = http.request(request)

document = REXML::Document.new(response.body)

if document.root.elements.empty?
  puts "No resources to list.."
else
  document.elements.each('/contents/content') do |element|
    id = element.elements['id'].text
    title = element.elements['title'].text
    puts id.ljust(6) + title
  end
end